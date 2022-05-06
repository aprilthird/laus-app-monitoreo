//
//  TriajeUnicoPresenter.swift
//  TempoMonitoring
//
//  Created by Jose Silva on 13/09/21.
//  Copyright © 2021 Sportafolio SAC. All rights reserved.
//

import Foundation

final class TriajeUnicoPresenter: TriajeDinamicoProtocol{

    var data: mCuestionarioModel = mCuestionarioModel()
    var respuestasInicial: respuestasDTO?
    
    func loadModel() -> mCuestionarioModel {
        let encuestaDao = EncuestasTriajeDao()
        let result = encuestaDao.getDataFromDB()
        if let item = result.first {
            if item.success {
                if let cuestionario = item.payload?.cuestionario {
                    self.data = cuestionario.cuestionarioInicial!
                }
            }
        }
        print("TriajeUnicoPresenter ---> loadModel: \(data)")
        return data
    }
    
    func initializeSections() -> respuestasDTO {
        let sections = data.parsetoDTO()
        let idCuestionario = data._id ?? ""
        let id = "\(Utils().DateToString(fecha: Date(), format: "yyyyMMdd"))\(idCuestionario)"
        
        respuestasInicial = respuestasDTO(
            id: id,
            tipoEncuesta: tipoCuestionario.inicial.rawValue,
            idEncuesta: idCuestionario,
            secciones: sections)
        
        return respuestasInicial!
    }
    
    func saveModel(section: respuestasDTO) {
        let respuestaDao = RespuestasDao()
        let rpta = mRespuestas()
        rpta.id = section.id
        rpta.idEncuesta = section.idEncuesta
        rpta.tipoEncuesta = section.tipoEncuesta
        rpta.generateId()
        rpta.log()
        for item in section.secciones {
            let _seccion = mSecciones()
            _seccion.nombre_seccion = item.nombreSeccion
            _seccion.numero_pasos = item.numeroPasos
            _seccion.numero_seccion = item.numeroSeccion
            _seccion.titulo_seccion = item.tituloSeccion
            
            for paso in item.pasos {
                let _paso = mPasos()
                
                _paso.cuadro_texto?.etiqueta = paso.cuadroTexto?.etiqueta
                _paso.cuadro_texto?.valor = paso.cuadroTexto?.valor
                _paso.data_colaborador = paso.dataColaborador
                _paso.id_pregunta_cuestionario = paso.idPreguntaCuestionario
                _paso.id_tipo_pregunta = paso.idTipoPregunta
                _paso.numero_paso = paso.numeroPaso
                _paso.pregunta = paso.pregunta
                _paso.requerido = paso.requerido
                _paso.respuestaInt = paso.respuestaInt ?? 0
                _paso.respuestaStr = paso.respuesta ?? ""
                _paso.texto_apoyo = paso.textoApoyo
                _paso.tipo_pregunta = paso.tipoPregunta
                
                for pregunta in paso.dataPregunta ?? [DataPregunta]() {
                    let _pregunta = mDataPregunta()
                    
                    _pregunta.etiqueta = pregunta.etiqueta
                    _pregunta.id_opcion = pregunta.idOpcion
                    _pregunta.valor = pregunta.valor
                    _paso.data_pregunta.append(_pregunta)
                }
                
                if let pregs = paso.respuestaObj {
                    for respuesta in pregs {
                        let _respuesta = mDataRespuesta()
                        _respuesta.etiqueta = respuesta.etiqueta
                        _respuesta.id_opcion = respuesta.idOpcion
                        _respuesta.seleccionado = respuesta.seleccionado
                        _respuesta.valor = respuesta.valor
                        _paso.respuesta.append(_respuesta)
                    }
                }
                
                _seccion.pasos.append(_paso)
            }
            
            rpta.secciones.append(_seccion)
        }
        rpta.log()
        respuestaDao.insert(triaje: rpta)
        
    }
    
}
