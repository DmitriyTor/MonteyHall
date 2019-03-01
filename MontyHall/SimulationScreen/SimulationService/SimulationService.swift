//
//  SimulationService.swift
//  MontyHall
//
//  Created by Admin on 28/02/2019.
//  Copyright © 2019 DmitriyToropkin. All rights reserved.
//

import Foundation


//Cоздадим очередь для выполнения не на Main Thread
let queueSimulation = DispatchQueue.global(qos: .utility)
//Создадим переменную задания подсчета, дабы была возможность отменить задачу
var workItem: DispatchWorkItem?


class SimulationService {
    
    private init() {}
    
    
    //Функция симуляции выбора при withCountRounds-количестве попыток, doorsCount-количеством дверей
    static func simulateGame(withCountRounds count: Int, withDoorsCount doorsCount: Int,  isChangeDoor: Bool, completion: @escaping (_ winCount: Int, _ percentWinner: Double, _ chanceToWin: Double) -> () ){
        
        //Переменные для подсчета количества побед и вероятности выигрыша
        var winCountOriginalChoose = 0
        var winCountChangedChoose = 0
        var percentWinner = 0.0
        var winCount = 0
        var chanceToWin = 0.0
        
        //Создадим задачу для подсчета вероятности победы
        workItem = DispatchWorkItem{
            
            //Симуляция игры
            for _ in (0..<count){
                
                //Отменим операцию, если была нажата кнопка отмены на hud-e
                guard let item = workItem else { return }
                if item.isCancelled { return }
                
                //Создадим призовую дверь и выбранную игроком
                let doorWithPrize = Int.random(in: 1...doorsCount)
                let choosedDoor = Int.random(in: 1...doorsCount)
                
                
                //Ведущий открывает дверь, но она не должна быть выбранной игроком или призовой
                var openDoor = 0
                repeat {
                    openDoor = Int.random(in: 1...doorsCount)
                } while openDoor == doorWithPrize || openDoor == choosedDoor
                
                
                //Игрок выбирает другую дверь
                var otherChosedDoor = 0
                repeat {
                    otherChosedDoor = Int.random(in: 1...doorsCount)
                } while otherChosedDoor == openDoor || otherChosedDoor == choosedDoor
                
                //Подсчитаем количество побед при выборе другой двери
                if otherChosedDoor == doorWithPrize{
                    winCountChangedChoose += 1
                }
                
                
                //Если выбор не менялся
                if choosedDoor == doorWithPrize{
                    winCountOriginalChoose += 1
                }
            }
            
            
            //Подготовим результаты работы
            switch isChangeDoor {
            case true:
                percentWinner = Double(winCountChangedChoose) / Double(count) * 100
                winCount = winCountChangedChoose
            default:
                percentWinner = Double(winCountOriginalChoose) / Double(count) * 100
                winCount = winCountOriginalChoose
            }
            
            chanceToWin = Double(winCountChangedChoose) / Double(winCountOriginalChoose)
            
            //Вернемся на главную очередб и передадим complection-блок с результатами
            DispatchQueue.main.async {
                completion(winCount, percentWinner.rounded(toPlaces: 2), chanceToWin.rounded(toPlaces: 3))
            }
            
        }
        //Запустим операцию
        queueSimulation.async(execute: workItem!)
    }
    
}




