//
//  TriajePreguntasCell.swift
//  TempoMonitoring
//
//  Created by Manuel Alejandro López Corrales on 9/9/21.
//  Copyright © 2021 Sportafolio SAC. All rights reserved.
//

import UIKit

class TriajePreguntasCell: UITableViewCell {
    @IBOutlet weak var lblPregunta: UILabel!
    @IBOutlet weak var tblRespuestas: UITableView!
    
    var pregunta: mPasos = mPasos()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tblRespuestas.delegate = self
        tblRespuestas.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(pregunta: mPasos) {
        self.pregunta = pregunta
        lblPregunta.text = pregunta.pregunta
        if pregunta.requerido {
            let mutableString = NSMutableAttributedString(string: "\(pregunta.pregunta) (*)", attributes: [
                NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 16)
            ])
            mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location: pregunta.pregunta!.count, length: 4))
            lblPregunta.attributedText = mutableString
        }
        tblRespuestas.reloadData()
    }
}
extension TriajePreguntasCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("rows: \(pregunta.data_pregunta.count)")
        return pregunta.data_pregunta.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = pregunta.data_pregunta[indexPath.item].etiqueta
        return cell
    }
    
    
}
