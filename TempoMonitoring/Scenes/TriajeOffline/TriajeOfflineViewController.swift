//
//  TriajeOfflineViewController.swift
//  TempoMonitoring
//
//  Created by Jose Silva on 20/08/21.
//  Copyright © 2021 Sportafolio SAC. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import RealmSwift

class TriajeOfflineViewController: UIViewController, TriajeOfflineViewControllerProtocol {
    
    var presenter: TriajeOfflinePresenterProtocol!

    @IBOutlet weak var viewTopBar: UIView!
    @IBOutlet weak var navigationBarTitle: UINavigationBar!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var txNombres: SkyFloatingLabelTextField!
    @IBOutlet weak var txApellidos: SkyFloatingLabelTextField!
    @IBOutlet weak var txApellidoMaterno: SkyFloatingLabelTextField!
    @IBOutlet weak var txSexo: SkyFloatingLabelTextField!
    @IBOutlet weak var txDepartamento: SkyFloatingLabelTextField!
    @IBOutlet weak var txProvincia: SkyFloatingLabelTextField!
    @IBOutlet weak var txDistrito: SkyFloatingLabelTextField!
    @IBOutlet weak var txDireccion: SkyFloatingLabelTextField!
    @IBOutlet weak var txContactoCelular: SkyFloatingLabelTextField!
    @IBOutlet weak var txContactoEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var txFamiliarNombres: SkyFloatingLabelTextField!
    @IBOutlet weak var txFamiliarCelular: SkyFloatingLabelTextField!
    
    private var pickerSexo = UIPickerView()
    private var pickerDepartamento = UIPickerView()
    private var pickerProvincia = UIPickerView()
    private var pickerDistrito = UIPickerView()
    var opcSexo: [String] = []
    var opcDepartments = [String]()
    var opcProvincia = [Provincia]()
    var opcDistrito =  [Distrito]()
    @IBOutlet weak var btConfirmaDatos: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFormularioLleno() {
            siguienteSeccion()
            return
        }
        configUI()
        presenter.loadOptions()
    }
    
    func isFormularioLleno() -> Bool {
        let triajeDao = TriajeDao()
        let triaje = triajeDao.getDataFromDB()
        return triaje.count != 0
    }
    
    func configUI(){
        btConfirmaDatos.layer.cornerRadius = 10
        self.pickerSexo.delegate = self
        self.pickerDepartamento.delegate = self
        self.pickerProvincia.delegate = self
        self.pickerDistrito.delegate = self
        self.pickerSexo.tag = 1
        self.pickerDepartamento.tag = 2
        self.pickerProvincia.tag = 3
        self.pickerDistrito.tag = 4
        txSexo.inputView = self.pickerSexo
        txDepartamento.inputView = self.pickerDepartamento
        txProvincia.inputView = self.pickerProvincia
        txDistrito.inputView = self.pickerDistrito
        
        txContactoCelular.keyboardType = .phonePad
        txFamiliarCelular.keyboardType = .phonePad
        txContactoEmail.keyboardType = .emailAddress

    }
    var index = 0
    func selectedElement(){
        index = opcDepartments.count
        pickerDepartamento.selectRow(index, inComponent: 0, animated: true)
        let xx = pickerDepartamento.selectedRow(inComponent: 0)
        txDepartamento.text = opcDepartments[xx]
    }
    
    var dataTriaje: mTriajeInformacionPersonal?
    @IBAction func tapConfirmarDatos(_ sender: Any) {
        if let triaje = validarCampos() {
            print("__Triaje: Guardando....")
            let triajeDao: TriajeDao = TriajeDao()
            triajeDao.insert(triaje: triaje)
            // Ir a triaje dinamico
            siguienteSeccion()
        }
    }
    
    func siguienteSeccion() {
        performSegue(withIdentifier: "sgTriajeDinamico", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! TriajeDinamicoViewController
        vc.presenter = TriajeUnicoPresenter()
    }
    
    func validarCampos()-> mTriajeInformacionPersonal? {
        
        if !presenter.validaEmail(email: txContactoEmail.text ?? "") {
            let alert = UIAlertController(title: "Atención", message: "Debe ingresar un email válido. Por favor, verifique...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return nil
        }
        
        if let nombre = txNombres.text?.replacingOccurrences(of: " ", with: ""), !nombre.isEmpty,
           let apellidos = txApellidos.text?.replacingOccurrences(of: " ", with: ""),  !apellidos.isEmpty,
           let apellidoMaterno = txApellidoMaterno.text?.replacingOccurrences(of: " ", with: ""), !apellidoMaterno.isEmpty,
           let sexo = txSexo.text, !sexo.isEmpty,
           let dept = txDepartamento.text, !dept.isEmpty,
           let provincia = txProvincia.text, !provincia.isEmpty,
           let distrito = txDistrito.text, !distrito.isEmpty,
           let direccion = txDireccion.text, !direccion.isEmpty,
           let telefono = txContactoCelular.text, !telefono.isEmpty,
           let email = txContactoEmail.text?.replacingOccurrences(of: " ", with: ""), !email.isEmpty,
           let familiarNombre = txFamiliarNombres.text?.replacingOccurrences(of: " ", with: ""), !familiarNombre.isEmpty,
           let familiarCelular = txFamiliarCelular.text, !familiarCelular.isEmpty {
            
            dataTriaje = mTriajeInformacionPersonal(nombres: nombre, apellidoPaterno: apellidos, apellidoMaterno: apellidoMaterno, sexo: sexo, departamento: dept, provincia: provincia, distrito: distrito, direccion: direccion, telefono: telefono, correoElectronico: email, familiarNombres: familiarNombre, familiarTelefono: familiarCelular, status: "P")
            
            return dataTriaje
            
        } else {
            let alert = UIAlertController(title: "Atención", message: "Debe ingresar información en todos los campos. Por favor, verifique...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return nil
        }
    }
    
    func configKeyboardAndPickers(){
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let okButton = UIBarButtonItem(title: "Aceptar", style: .plain, target: self, action: #selector(self.dissmissPickers))
        toolbar.setItems([okButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        txSexo.inputAccessoryView = toolbar
    }
    
    @objc func dissmissPickers(sender: UITextField)
    {
        if txSexo.text != "Seleccione..." {
            txSexo.endEditing(true)
        }
    }

    // MARK: - Protocol ViewController
    func updateOpcSexo(options: [String]) {
        self.opcSexo = options
    }
    func updateOpcsDepartmentos(options: [String]){
        self.opcDepartments = options
        self.opcDepartments.insert("Seleccione...", at: 0)
        self.pickerDepartamento.reloadAllComponents()
        self.pickerDepartamento.selectRow(0, inComponent: 0, animated: false)
    }
    
    func updateOpcProvincia(options: [Provincia]){
        self.opcProvincia = options
        self.opcProvincia.insert(Provincia(Departamento: "", Provincia: "Seleccione..."), at: 0)
        self.pickerProvincia.selectRow(0, inComponent: 0, animated: false)
        self.pickerProvincia.reloadAllComponents()
    }
    func updateOpcDistrito(options: [Distrito]){
        self.opcDistrito = options
        self.opcDistrito.insert(Distrito(Departamento: "", Provincia: "", Distrito: "Seleccione..."), at: 0)
        self.pickerDistrito.selectRow(0, inComponent: 0, animated: false)
        self.pickerDistrito.reloadAllComponents()
    }
}

extension TriajeOfflineViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return opcSexo.count
        case 2:
            return opcDepartments.count
        case 3:
            return opcProvincia.count
        case 4:
            return opcDistrito.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return opcSexo[row]
        case 2:
            return opcDepartments[row]
        case 3:
            return opcProvincia[row].Provincia
        case 4:
            return opcDistrito[row].Distrito
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            txSexo.text = opcSexo[row] != "Seleccione..." ? opcSexo[row] : ""
        case 2:
            txDepartamento.text = opcDepartments[row] != "Seleccione..." ? opcDepartments[row] : ""
            txProvincia.text = ""
            txDistrito.text = ""
            presenter.loadProvincia(departamento: txDepartamento.text ?? "")
            opcDistrito = [Distrito]()
        case 3:
            txProvincia.text = opcProvincia[row].Provincia != "Seleccione..." ? opcProvincia[row].Provincia : ""
            txDistrito.text = ""
            presenter.loadDistritos(departamento: txDepartamento.text ?? "", provincia: txProvincia.text ?? "")
        case 4:
            txDistrito.text = opcDistrito[row].Distrito != "Seleccione..." ? opcDistrito[row].Distrito : ""
        default:
            print("Ningun picker")
        }
        
    }
    
}
