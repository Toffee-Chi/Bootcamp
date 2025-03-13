//
//  main.swift
//  RELOJ
//
//  Created by Bootcamp on 2025-02-24.
//

import Foundation

//RELOJ CLASE EN XCODE


class Reloj {
    private var horas: Int
    private var minutos: Int
    private var segundos: Int
    
    init() {
        self.horas = 0
        self.minutos = 0
        self.segundos = 0
    }
    
    // Setea el reloj basado en segundos desde medianoche
    func setReloj(_ segundosTotales: Int) {
        let segundosRestantes = segundosTotales % (24 * 3600) // Asegura que no exceda 24 horas
        self.horas = segundosRestantes / 3600
        self.minutos = (segundosRestantes % 3600) / 60
        self.segundos = segundosRestantes % 60
    }
    
    // las funciones de get para la clase
    func getHoras() -> Int {
        return horas
    }
    
    func getMinutos() -> Int {
        return minutos
    }
    
    func getSegundos() -> Int {
        return segundos
    }
    
    // los set solicitados para la creacion del reloj
    func setHoras(_ horas: Int) {
        self.horas = horas % 24 // Asegura que las horas estén entre 0-23
    }
    
    func setMinutos(_ minutos: Int) {
        self.minutos = minutos % 60 // Asegura que los minutos estén entre 0-59
    }
    
    func setSegundos(_ segundos: Int) {
        self.segundos = segundos % 60 // Asegura que los segundos estén entre 0-59
    }
    
    // Incrementa un segundo
    func tick() {
        segundos += 1
        if segundos >= 60 {
            segundos = 0
            minutos += 1
            if minutos >= 60 {
                minutos = 0
                horas += 1
                if horas >= 24 {
                    horas = 0
                }
            }
        }
    }
    
    // Decrementa un segundo
    func tickDecrement() {
        segundos -= 1
        if segundos < 0 {
            segundos = 59
            minutos -= 1
            if minutos < 0 {
                minutos = 59
                horas -= 1
                if horas < 0 {
                    horas = 23
                }
            }
        }
    }
    
    // Suma otro reloj al actual
    func addReloj(_ otroReloj: Reloj) {
        let totalSegundos = (self.horas * 3600 + self.minutos * 60 + self.segundos) +
                           (otroReloj.getHoras() * 3600 + otroReloj.getMinutos() * 60 + otroReloj.getSegundos())
        setReloj(totalSegundos)
    }
    
    // Representa el reloj como string en formato [hh:mm:ss]
    func toString() -> String {
        let horasStr = horas < 10 ? "0\(horas)" : "\(horas)"
        let minutosStr = minutos < 10 ? "0\(minutos)" : "\(minutos)"
        let segundosStr = segundos < 10 ? "0\(segundos)" : "\(segundos)"
        return "[\(horasStr):\(minutosStr):\(segundosStr)]"
    }
}
//probamos la class reloj
let reloj1 = Reloj()
let reloj2 = Reloj()

reloj1.setHoras(10)
reloj1.setMinutos(30)
reloj1.setSegundos(45)

reloj2.setHoras(3)
reloj2.setMinutos(45)
reloj2.setSegundos(30)

print("Reloj 1: \(reloj1.toString())")
print("Reloj 2: \(reloj2.toString())")
