//
//  TriajeDinamicoViewController.swift
//  TempoMonitoring
//
//  Created by Manuel Alejandro López Corrales on 9/9/21.
//  Copyright © 2021 Sportafolio SAC. All rights reserved.
//

import UIKit
enum tipoCuestionario: String {
    case undefined = "undefined"
    case inicial = "inicial"
    case diario = "diario"
    case atencion = "atencion"
}

class TriajeDinamicoViewController: UIViewController {
    @IBOutlet weak var tblTriaje: UITableView!
    @IBOutlet weak var backgroundPopOver: UIView!
    @IBOutlet weak var popOver: UIView!
    
    var presenter: TriajeDinamicoProtocol!
    private var data: mCuestionarioModel = mCuestionarioModel()
    private var sections: respuestasDTO!
    
    var cuestionarioAcual: tipoCuestionario = .undefined
    var seccionActual: Int = 0
    var subSeccion: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = presenter.loadModel()
        sections = presenter.initializeSections()
        cuestionarioAcual = tipoCuestionario(rawValue: sections.tipoEncuesta) ?? .undefined
        
        configTable()
        configurarPopOver()
        
    }
    
    // MARK: - Config Tableview
    func configTable(){
        tblTriaje.delegate = self
        tblTriaje.dataSource = self
        tblTriaje.register(UINib(nibName: "CellOM", bundle: nil), forCellReuseIdentifier: "CellOM")
        tblTriaje.register(UINib(nibName: "CellTF", bundle: nil), forCellReuseIdentifier: "CellTF")
        tblTriaje.register(UINib(nibName: "CellOS", bundle: nil), forCellReuseIdentifier: "CellOS")
        tblTriaje.register(UINib(nibName: "CellDP", bundle: nil), forCellReuseIdentifier: "CellDP")
        tblTriaje.register(UINib(nibName: "CellSN", bundle: nil), forCellReuseIdentifier: "CellSN")
        tblTriaje.tableFooterView = getFooter()
        tblTriaje.backgroundColor = UIColor.white
        tblTriaje.sectionIndexBackgroundColor = UIColor.white
    }

    func getFooter() -> UIView {
        let view = UIView()
        view.frame.size.height = 290
        
        let lblRequired = UILabel()
        lblRequired.text = "Los campos obligatorios son los que se muestren con asterisco (*)"
        lblRequired.textColor = UIColor.red
        lblRequired.translatesAutoresizingMaskIntoConstraints = false
        lblRequired.numberOfLines = 0
        lblRequired.textAlignment = .center
        lblRequired.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        view.addSubview(lblRequired)
        view.addConstraints([
            NSLayoutConstraint(item: lblRequired, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 16),
            NSLayoutConstraint(item: lblRequired, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 16),
            NSLayoutConstraint(item: lblRequired, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -16)
        ])
        
        let lblTerminos = UILabel()
        lblTerminos.text = "Todos los datos expresados en esta ficha constituyen declaración jurada de mi parte.\nHe sido informado que de omitir o falsear información puedo perjudicar la salud de mis compañeros, y la mía propia, lo cual de constituir una falta grave a la salud pública, asumo sus consecuencias."
        lblTerminos.translatesAutoresizingMaskIntoConstraints = false
        lblTerminos.numberOfLines = 0
        lblTerminos.textAlignment = .center
        lblTerminos.font = UIFont(name: "AvenirNext-Regular", size: 12)
        view.addSubview(lblTerminos)
        view.addConstraints([
            NSLayoutConstraint(item: lblTerminos, attribute: .top, relatedBy: .equal, toItem: lblRequired, attribute: .bottom, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: lblTerminos, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 32),
            NSLayoutConstraint(item: lblTerminos, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -32)
        ])
        
        let btnContinuar = UIButton()
        btnContinuar.isUserInteractionEnabled = true
        btnContinuar.layer.cornerRadius = 10
        btnContinuar.setTitle("CONTINUAR", for: .normal)
        btnContinuar.translatesAutoresizingMaskIntoConstraints = false
        btnContinuar.backgroundColor = UIColor.init("0074ff")
        btnContinuar.addTarget(self, action: #selector(siguienteSeccion(sender:)), for: .touchUpInside)
        view.addSubview(btnContinuar)
        
        btnContinuar.topAnchor.constraint(equalTo: lblTerminos.bottomAnchor, constant: 16).isActive = true
        btnContinuar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        btnContinuar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        btnContinuar.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        let btnRegresar = UIButton()
        btnRegresar.isUserInteractionEnabled = true
        btnRegresar.setTitle("Regresar", for: .normal)
        btnRegresar.setTitleColor(UIColor.lightGray, for: .normal)
        btnRegresar.translatesAutoresizingMaskIntoConstraints = false
        btnRegresar.addTarget(self, action: #selector(anteriorSeccion(sender:)), for: .touchUpInside)
        view.addSubview(btnRegresar)
        view.addConstraints([
            NSLayoutConstraint(item: btnRegresar, attribute: .top, relatedBy: .equal, toItem: btnContinuar, attribute: .bottom, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: btnRegresar, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: btnRegresar, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -16)
        ])
        
        return view
    }
    
    func configurarPopOver() {
        popOver.layer.cornerRadius = 10
    }
    
    func guardarModal() {
        if validaObligatorios() {
            presenter.saveModel(section: sections)
            
            UIView.animate(withDuration: 0.8, animations: {
                self.popOver.alpha = 1
                self.backgroundPopOver.alpha = 0.5
            })
            
        } else {
            let alert = UIAlertController(title: "Atención", message: "Debe responder todos los campos obligatorios", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func guardarCuestionario(_ sender: Any) {
        if validaObligatorios() {
            presenter.saveModel(section: sections)
            
            if cuestionarioAcual == .inicial {
                let diario = Router.shared.showTriajeDiario()
                show(diario, sender: nil)
            } else if cuestionarioAcual == .diario {
                self.cerrarModal(nil)
                if NetworkStatus.shared.isOn {
                    let mainTabBar = Router.shared.getMainTabBar()
                    crossDisolveTransition(to: mainTabBar)
                } else {
                    let alertOffline = OfflinePopupViewController()
                    alertOffline.modalPresentationStyle = .overCurrentContext
                    alertOffline.modalTransitionStyle = .crossDissolve
                    self.present(alertOffline, animated: true, completion: nil)
                }
            }
            
        } else {
            let alert = UIAlertController(title: "Atención", message: "Debe responder todos los campos obligatorios", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        

    }
    
    @objc func cerrarModal(_ sender: UITapGestureRecognizer?) {
        UIView.animate(withDuration: 0.8, animations: {
            self.popOver.alpha = 0
            self.backgroundPopOver.alpha = 0
        })
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        performSegue(withIdentifier: "unwindMain", sender: self)
    }
    
    @objc func siguienteSeccion(sender: UIButton!) {
        if self.cuestionarioAcual == .inicial {
            if self.subSeccion == 0 {
                self.subSeccion = 1
            } else {
                guardarModal()
            }
        } else if self.cuestionarioAcual == .diario {
            if self.subSeccion == self.sections.secciones.count - 1 {
                guardarModal()
            } else {
                self.subSeccion += 1
            }
        } else {
            return
        }
        self.tblTriaje.reloadData()
        self.tblTriaje.focusItems(in: .zero)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            let indexPath = IndexPath(row: 0, section: 0)
            self.tblTriaje.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func validaObligatorios() -> Bool{

        var valido = true
        
        for currentSection in sections.secciones {
            for indPasos in currentSection.pasos {
                if indPasos.requerido {
                    var validoPregunta = false
                    switch indPasos.tipoPregunta {
                    case "SELECCION_MULTIPLE", "SELECCION_SIMPLE_DESPLEGABLE", "SI_NO":
                        if let _preg = indPasos.respuestaObj {
                            for preguntas in _preg {
                                validoPregunta = validoPregunta || preguntas.seleccionado
                            }
                        }
                    case "NUMBER":
                        validoPregunta = indPasos.respuestaInt ?? 0 > 0
                    case "TEXTO", "FECHA":
                        validoPregunta = indPasos.respuesta ?? "" > ""
                    default:
                        print("")
                    }
                    valido = valido && validoPregunta
                }
            }
        }
        return valido
    }
    
    @objc func anteriorSeccion(sender: UIButton!) {
        if self.cuestionarioAcual == .inicial {
            if self.subSeccion == 1 {
                self.subSeccion = 0
            } else {
                // nada
            }
        } else if self.cuestionarioAcual == .diario {
            if self.subSeccion > 0 {
                self.subSeccion -= 1
            }
        }
        tblTriaje.focusItems(in: .zero)
//        tblTriaje.setContentOffset(.zero, animated: true)
        self.tblTriaje.reloadData()
    }
}

extension TriajeDinamicoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.cuestionarioAcual == .inicial {
            if self.subSeccion == 0 {
                return 1
            }
            if sections.secciones.count > 0 {
                return sections.secciones.count - 1
            }
            return 0
        } else if self.cuestionarioAcual == .diario {
            return 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lblSection = UILabel()
        lblSection.font = UIFont.boldSystemFont(ofSize: 22)
        if self.cuestionarioAcual == .inicial {
            if self.subSeccion == 0 {
                lblSection.text = "   \(sections.secciones[self.subSeccion].tituloSeccion)"
            } else {
                lblSection.text = "   \(sections.secciones[self.subSeccion].tituloSeccion)"
            }
        } else if self.cuestionarioAcual == .diario {
            lblSection.text = "   \(sections.secciones[self.subSeccion].tituloSeccion)"
        }
        return lblSection
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "ABC"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var sectionIdx = section
        if self.cuestionarioAcual == .inicial && self.subSeccion == 1 {
            sectionIdx += 1
        }
        if self.cuestionarioAcual == .diario {
            sectionIdx = self.subSeccion
        }
        return self.data.secciones[sectionIdx].pasos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var sectionIdx = indexPath.section
        if self.cuestionarioAcual == .inicial && self.subSeccion == 1 {
            sectionIdx += 1
        }
        if self.cuestionarioAcual == .diario {
            sectionIdx = self.subSeccion
        }
        let item = sections.secciones[sectionIdx].pasos[indexPath.row] //[sectionIdx].pasos[indexPath.item]
        
        let pregunta = item.pregunta
        let marca = "(*)"
        let attrPregunta: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        let attrMarca: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular),
            NSAttributedString.Key.foregroundColor: UIColor.red
        ]
        
        let joinText = [pregunta, marca].joined(separator: " ")
        let attributedString = NSMutableAttributedString(string: joinText)
        let range1 = attributedString.mutableString.range(of: pregunta)
        let range2 = attributedString.mutableString.range(of: marca)
        
        attributedString.addAttributes(attrPregunta, range: range1)
        attributedString.addAttributes(attrMarca, range: range2)
        
        
        if item.tipoPregunta == "SELECCION_MULTIPLE" {
            // Cargar UI
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellOM", for: indexPath) as! CellOM
            if item.requerido {
                cell.lbPregunta.attributedText = attributedString
            } else {
                cell.lbPregunta.text = item.pregunta
            }
            
            cell.index = indexPath
            cell.delegateResponse = self
            cell.delegateCuadroTexto = self
            cell.addItems(opciones: item.dataPregunta!,
                          respuestas: item.respuestaObj ?? [],
                          cuadroTexto: item.cuadroTexto?.etiqueta)
            if cell.textField != nil {
                cell.textField!.text = item.cuadroTexto?.valor
            }
            return cell
        } else if item.tipoPregunta == "NUMBER" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellTF", for: indexPath) as! CellTF
            cell.type = .NUMBER
            if item.requerido {
                cell.lbPregunta.attributedText = attributedString
            } else {
                cell.lbPregunta.text = item.pregunta
            }
            cell.configKeyboard()
            cell.textField.placeholder = "Ingrese respuesta..."
            cell.textField.title = ""
            cell.lbPregunta.font = UIFont(name: "AvenirNext-Regular", size: 14)
            cell.textField.font = UIFont(name: "AvenirNext-Regular", size: 14)
            cell.delegateResponse = self
            cell.index = indexPath
            cell.textField.text = String(item.respuestaInt ?? 0)
            return cell
        } else if item.tipoPregunta == "SELECCION_SIMPLE_DESPLEGABLE" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellOS", for: indexPath) as! CellOS
            cell.required = item.requerido
            if item.requerido {
                cell.lbPregunta.attributedText = attributedString
            } else {
                cell.lbPregunta.text = item.pregunta
            }
            cell.picker.font = UIFont(name: "AvenirNext-Regular", size: 14)
            cell.lbPregunta.numberOfLines = 0
            cell.picker.placeholder = "Seleccione..."
            cell.picker.title = ""
            var opciones = [String]()
            for opcion in item.dataPregunta ?? [] {
                opciones.append(opcion.etiqueta)
            }
            
            var seleccion = ""
            if let _rpta = item.respuestaObj {
                for rpta in _rpta {
                    if rpta.seleccionado {
                        seleccion = rpta.etiqueta
                    }
                }
            }
            if item.cuadroTexto?.etiqueta != nil {
                cell.cuadroTexto = item.cuadroTexto?.etiqueta
                cell.delegateCuadroTexto = self
            }
            if cell.textField != nil {
                cell.textField!.text = item.cuadroTexto?.valor
            }
            cell.alternativas = opciones.joined(separator: "|")
            cell.picker.text = seleccion
            cell.index = indexPath
            cell.delegateResponse = self
            return cell
        } else if item.tipoPregunta == "TEXTO" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellTF", for: indexPath) as! CellTF
            cell.type = .TEXT
            if item.requerido {
                cell.lbPregunta.attributedText = attributedString
            } else {
                cell.lbPregunta.text = item.pregunta
            }
            cell.configKeyboard()
            cell.textField.placeholder = "Escriba aquí..."
            cell.textField.title = ""
            cell.lbPregunta.font = UIFont(name: "AvenirNext-Regular", size: 14)
            cell.textField.font = UIFont(name: "AvenirNext-Regular", size: 14)
            cell.delegateResponse = self
            cell.index = indexPath
            cell.textField.text = item.respuesta
            return cell
        } else if item.tipoPregunta == "FECHA" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellDP", for: indexPath) as! CellDP
            if item.requerido {
                cell.lbPregunta.attributedText = attributedString
            } else {
                cell.lbPregunta.text = item.pregunta
            }
            cell.lbPregunta.font = UIFont(name: "AvenirNext-Regular", size: 14)
            cell.txDate.font = UIFont(name: "AvenirNext-Regular", size: 14)
            cell.txDate.placeholder = "Seleccione..."
            cell.txDate.title = ""
            cell.delegateResponse = self
            cell.index = indexPath
            cell.customInput()
            
            return cell
        } else if item.tipoPregunta == "SI_NO" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellSN", for: indexPath) as! CellSN
            cell.lbPregunta.font = UIFont(name: "AvenirNext-Regular", size: 14)
            cell.delegateResponse = self
            cell.delegateCuadroTexto = self
            cell.index = indexPath
            
            if item.requerido {
                cell.lbPregunta.attributedText = attributedString
            } else {
                cell.lbPregunta.text = item.pregunta
            }
            
            cell.addItems(opciones: item.dataPregunta!,
                          respuestas: item.respuestaObj ?? [],
                          cuadroTexto: item.cuadroTexto?.etiqueta)

            if cell.textField != nil {
                cell.textField!.text = item.cuadroTexto?.valor
            }
            return cell
        }
        let cell = UITableViewCell()
        return cell
    }
}

extension TriajeDinamicoViewController: CustomCellResponseDelegate {
    func getResponse(value: String?, index: Int, group: Int, cell: UITableViewCell) {
        
        var section: Int = group
        if self.cuestionarioAcual == .inicial && self.subSeccion == 1 {
            section += 1
        }
        if self.cuestionarioAcual == .diario {
            section = self.subSeccion
        }
        let item = sections.secciones[section].pasos[index]
        if item.tipoPregunta == "SELECCION_MULTIPLE" ||
            item.tipoPregunta == "SELECCION_SIMPLE_DESPLEGABLE" ||
            item.tipoPregunta == "SI_NO" {
            var indRpta = 0
            if let _obj = sections.secciones[section].pasos[index].respuestaObj {
                for obj in _obj {
                    let check = obj.seleccionado
                    if let concat = value {
                        let isEqual = concat.contains(obj.etiqueta)
                        
                        if item.tipoPregunta == "SI_NO" {
                            sections.secciones[section].pasos[index].respuestaObj?[indRpta].seleccionado = isEqual
                        }
                        
                        if isEqual {
                            if item.tipoPregunta == "SI_NO" {
                                if let cell = cell as? CellSN {
                                    if isEqual {
                                        cell.unSelectAll(except: indRpta)
                                    }
                                }
                            } else {
                                // Si es "sin_sintomas"
                                if sections.secciones[section].pasos[index].respuestaObj?[indRpta].valor == "sin_sintomas" {
                                    // Si es seleccion multiple
                                    if let cell = cell as? CellOM {
                                        // Si se hizo check
                                        if !check {
                                            cell.unSelectAll(lock: true, except: indRpta)
                                        } else {
                                            cell.unLockAll()
                                        }
                                    }
                                }
                                sections.secciones[section].pasos[index].respuestaObj?[indRpta].seleccionado = !check
                            }
                        }
                    }
                    indRpta += 1
                }
            }
        } else if item.tipoPregunta == "TEXTO" || item.tipoPregunta == "FECHA" {
            sections.secciones[section].pasos[index].respuesta = value!
        } else if item.tipoPregunta == "NUMBER" {
            if let value = value, let numero = Int(value) {
                sections.secciones[section].pasos[index].respuestaInt = numero
            }
        }
    }
    
    func lockCell(value: String?, index: Int, group: Int, cell: UITableViewCell) {
        var section: Int = group
        if self.cuestionarioAcual == .inicial && self.subSeccion == 1 {
            section += 1
        }
        if self.cuestionarioAcual == .diario {
            section = self.subSeccion
        }
        var indRpta = 0
        if let _obj = sections.secciones[section].pasos[index].respuestaObj {
            for obj in _obj {
                if let concat = value {
                    if concat.contains(obj.etiqueta) {
                        sections.secciones[section].pasos[index].respuestaObj?[indRpta].disabled = true
                    }
                }
                indRpta += 1
            }
        }
    }
    
    func unlockCell(value: String?, index: Int, group: Int, cell: UITableViewCell) {
        var section: Int = group
        if self.cuestionarioAcual == .inicial && self.subSeccion == 1 {
            section += 1
        }
        if self.cuestionarioAcual == .diario {
            section = self.subSeccion
        }
        var indRpta = 0
        if let _obj = sections.secciones[section].pasos[index].respuestaObj {
            for obj in _obj {
                if let concat = value {
                    if concat.contains(obj.etiqueta) {
                        sections.secciones[section].pasos[index].respuestaObj?[indRpta].disabled = false
                    }
                }
                indRpta += 1
            }
        }
    }
}

extension TriajeDinamicoViewController: CuadroTextoDelegate {
    func getCuadroTexto(value: String?, index: Int, group: Int) {
        var section: Int = group
        if self.cuestionarioAcual == .inicial && self.subSeccion == 1 {
            section += 1
        }
        if self.cuestionarioAcual == .diario {
            section = self.subSeccion
        }
        sections.secciones[section].pasos[index].cuadroTexto!.valor = value!
    }
}
