//
//  mRespuestas.swift
//  TempoMonitoring
//
//  Created by Jose Silva on 13/09/21.
//  Copyright © 2021 Sportafolio SAC. All rights reserved.
//

import Foundation
import RealmSwift

class mRespuestas: Object {
    @Persisted(primaryKey: true) var id = ""
    @Persisted var fechaCreacion = 0
    @Persisted var idEncuesta = ""
    @Persisted var tipoEncuesta = ""
    @Persisted var secciones: List<mSecciones>
    @Persisted var status = "P"
    
    override init() {
        super.init()
        self.id = "\(self.id)\(self.idEncuesta)"
        let fecha = Utils().DateToString(fecha: Date(), format: "yyyyMMdd")
        self.fechaCreacion = Int(fecha) ?? 0
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func generateId() {
        id = "\(self.id)\(self.idEncuesta)"
        let fecha = Utils().DateToString(fecha: Date(), format: "yyyyMMdd")
        self.fechaCreacion = Int(fecha) ?? 0
    }
    
    func log(){
        print("Log desde mRespuestas: \(id)")
    }
    
    func parsetoDTO() -> respuestasDTO {
        var lstSections = [Secciones]()
        
        for item in secciones {
            var pasosInSections = [Paso]()
            
            for itemPaso in item.pasos {
                let cuadro = CuadroTexto(etiqueta: itemPaso.cuadro_texto?.etiqueta ?? "", valor: itemPaso.cuadro_texto?.valor ?? "")
                
                print("Log CuadroTexto: \( cuadro.etiqueta ?? "NO HAY")")
                let cuadroTexto = cuadro
                var preguntasInPaso = [DataPregunta]()
                var respuestasInPaso = [DataRepuesta]()
                for preguntas in itemPaso.data_pregunta {
                    let preg = DataPregunta(idOpcion: preguntas.id_opcion ?? 0,
                                            etiqueta: preguntas.etiqueta ?? "",
                                            valor: preguntas.valor ?? "")
                    preguntasInPaso.append(preg)
                }
                for respuestas in itemPaso.respuesta {
                    let rpt = DataRepuesta(idOpcion: respuestas.id_opcion ?? 0,
                                           etiqueta: respuestas.etiqueta ?? "",
                                           valor: respuestas.valor ?? "",
                                           seleccionado: respuestas.seleccionado ?? false, disabled: respuestas.disabled ?? false)
                    respuestasInPaso.append(rpt)
                }
                
                
                let paso = Paso(cuadroTexto: cuadroTexto,
                                    dataPregunta: preguntasInPaso,
                                    idPreguntaCuestionario: itemPaso.id_pregunta_cuestionario,
                                    numeroPaso: itemPaso.numero_paso,
                                    pregunta: itemPaso.pregunta ?? "",
                                    textoApoyo: itemPaso.texto_apoyo ?? "",
                                    idTipoPregunta: itemPaso.id_tipo_pregunta,
                                    tipoPregunta: itemPaso.tipo_pregunta ?? "",
                                    requerido: itemPaso.requerido,
                                    valor: "",
                                    crearCaso: false,
                                    dataColaborador: itemPaso.data_colaborador,
                                    respuesta: itemPaso.respuestaStr,
                                    respuestaInt: itemPaso.respuestaInt, respuestaObj: respuestasInPaso)
                pasosInSections.append(paso)

            }
            
            let section = Secciones(pasos: pasosInSections,
                                    numeroSeccion: item.numero_seccion,
                                    nombreSeccion: item.nombre_seccion ?? "",
                                    tituloSeccion: item.titulo_seccion ?? "",
                                    numeroPasos: item.numero_pasos)
            lstSections.append(section)
        }
        
        let respuestas: respuestasDTO = respuestasDTO(id: self.id,
                                                         tipoEncuesta: self.tipoEncuesta,
                                                         idEncuesta: self.idEncuesta,
                                                         secciones: lstSections)
        return respuestas
    }
}
