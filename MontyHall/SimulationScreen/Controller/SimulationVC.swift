//
//  SimulationVC.swift
//  MontyHall
//
//  Created by Admin on 28/02/2019.
//  Copyright © 2019 DmitriyToropkin. All rights reserved.
//

import UIKit
import JGProgressHUD
import SnapKit

class SimulationVC: UIViewController {
    
    //MARK: - Начальные переменные
    //Создадим худ для отображения процесса подсчета
    var hud = JGProgressHUD(style: .dark)
    
    //Меняем дверь?
    var isDoorChanged = true
    
    
    //MARK: - Создаем все элементы интерфейса
   //Кнопка симуляции
    let simulateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Старт", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(startSimulationByButton), for: .touchUpInside)
        
        return button
    }()
    
    
    
    
    //текст филд для подсчета количества раундов
    let countRoundsTextField :UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Количество раундов",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 110/255, green: 110/255, blue: 110/255, alpha: 1)])
        
        textField.backgroundColor = UIColor(displayP3Red: 33/255, green: 32/255, blue: 35/255, alpha: 1)
        textField.textColor = .white
        textField.layer.cornerRadius = 15.0
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.setLeftPaddingPoints(20)
        textField.keyboardType = .numberPad
        
        return textField
    }()
    
    
    
    //сегментконтрол для выбора стратегии
    let segmentChoseOrOriginal: UISegmentedControl = {
        let items = ["Меняем дверь", "Не меняем дверь"]
        let segment = UISegmentedControl(items: items)
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(doorSetting), for: .valueChanged)
        segment.tintColor = UIColor(displayP3Red: 110/255, green: 110/255, blue: 110/255, alpha: 1)
        
        return segment
    }()
    
    
    
    
    //Ярлык для результата
    let resultLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(displayP3Red: 110/255, green: 110/255, blue: 110/255, alpha: 1)
        label.text = "Результат"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    
    
    //MARK: - Функция при запуске контроллера
    override func viewDidLoad() {
        //Настроим отображение
        setup()
        setupViews()
        
        super.viewDidLoad()
    }
    
    
    //MARK: - Настройки вьюшек
    //Настройка вью главного и навигейшнбара
    func setup(){
        view.backgroundColor = .black
        title = "Парадокс"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shouldRemoveShadow(true)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    
    
    
    //Быстрая настройка общего внешнего вида
    func setupViews(){
        view.addSubview(countRoundsTextField)
        view.addSubview(simulateButton)
        view.addSubview(segmentChoseOrOriginal)
        view.addSubview(resultLabel)
        
        //Установим все констрейнты
        
        countRoundsTextField.snp.makeConstraints { (make) in
            make.left.top.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(50)
        }
        
        segmentChoseOrOriginal.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(countRoundsTextField)
            make.top.equalTo(countRoundsTextField.snp.bottom).offset(50)
        }
        
        simulateButton.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(countRoundsTextField)
            make.top.equalTo(segmentChoseOrOriginal.snp.bottom).offset(50)
        }
        
        resultLabel.snp.makeConstraints { (make) in
            make.left.equalTo(countRoundsTextField).offset(20)
            make.right.equalTo(countRoundsTextField)
            make.top.equalTo(simulateButton.snp.bottom).offset(50)
            //make.height.equalTo(100)
        }
    }
    
    
    
    
    
    //MARK: - Запуск симуляции событий
    //Запуск симуляции событий
    @objc func startSimulationByButton(){
        
        //Уберем клавиатуру
        countRoundsTextField.resignFirstResponder()
        
        //Все по показу худа
        setupHudAndShow()
        
        //Достанем число из текстового поля
        guard let countRound = Int(countRoundsTextField.text!) else { return }
        
        //Запутим процесс подсчета
        SimulationService.simulateGame(withCountRounds: countRound, withDoorsCount: 3, isChangeDoor: isDoorChanged) { (winCount, percentWinner, chanceToWin) in
            self.resultLabel.text = "Количество побед: \(winCount) \nВероятность победы:  \(percentWinner)% \n\nШанс выиграть при смене двери был в \(chanceToWin) раз(а) больше"
            //отклюич худ
            self.showHudSuccessAndHide()
            self.resultLabel.sizeToFit()
        }
    }
    
    
  
    
    
    
    
    //MARK: - Настройки hud
    //Добавим жест тапа по худу для отмены и запустим сам худ
    func setupHudAndShow(){
        //запустим худ
        hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Считаем вероятность. \n Коснитесь для отмены."
        hud.show(in: self.view)
        //Добавим жест для отмены
        self.hud.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelButton))
        hud.contentView.addGestureRecognizer(tap)
    }
    //После нажатия на худ (отмена операции)
    @objc func cancelButton() {
        //Отменим задачу для освобождения ресурсов
        workItem?.cancel()
        //удалим жест, чтоб не возникло непредвиденных ситуаций
        hud.contentView.gestureRecognizers?.forEach(hud.contentView.removeGestureRecognizer)
        //анимация худа и сведения, что операция отменена
        UIView.animate(withDuration: 0.3) {
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView.init()
            self.hud.textLabel.text = "Операция отменена пользователем"
        }
        //Уберем худ через секунду
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.hud.dismiss()
        }
    }
    
    //Сигнал о успешности и скрытие худа
    func showHudSuccessAndHide(){
        //удалим жест, чтоб не возникло непредвиденных ситуаций
        hud.contentView.gestureRecognizers?.forEach(hud.contentView.removeGestureRecognizer)
        //Анимация успеха симуляции
        UIView.animate(withDuration: 0.5) {
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView.init()
            self.hud.textLabel.text = "Успешно!"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.hud.dismiss()
        }
    }
    
    
    
    //MARK: - Настройки сегментконтрол
    //для сегментера вбора стратегии
    @objc func doorSetting(sender: UISegmentedControl){
        if sender.selectedSegmentIndex == 0{
            isDoorChanged = true
        }
        if sender.selectedSegmentIndex == 1{
            isDoorChanged = false
        }
    }
    
    
}
