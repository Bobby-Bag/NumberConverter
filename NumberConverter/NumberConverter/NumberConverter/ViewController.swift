//
//  ViewController.swift
//  NumberConverter
//
//  Created by Bobby Bagley on 6/19/25.
//

import UIKit
// Set the ViewController as the Picker's delegate and data source.
class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    // Create instance of model. Forgot this during exam like a silly goose.
    let converterModel = ConversionModel()
  
// Play around with using Markup in comments:
    /// **Converter Outlets and Actions**
    @IBOutlet weak var converterView: UIView!
    @IBOutlet weak var baseSegmentedControl: UISegmentedControl!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var valueStepper: UIStepper!
    @IBOutlet weak var shiftLabel: UILabel!
    @IBOutlet weak var shiftStepper: UIStepper!
    @IBOutlet weak var actionPickerView: UIPickerView!
    @IBOutlet weak var maskLabel: UILabel!
    @IBOutlet weak var maskTextField: UITextField!
    @IBOutlet weak var generalResultLabel: UILabel!
    @IBOutlet weak var binaryResultLabel: UILabel!
    @IBOutlet weak var hexResultLabel: UILabel!
    @IBOutlet weak var octalResultLabel: UILabel!
    @IBOutlet weak var decimalResultLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBAction func numberTextFieldDidChange(_ sender: UITextField) {
        if let intValue = converterModel.stringToInt(fromString: sender.text ?? "", base: currentBase) {
                // Sync the stepper to what the user typed.
                valueStepper.value = Double(intValue)
            }
    }
    
    @IBAction func baseDidChange(_ sender: UISegmentedControl) {
    }
    
    @IBAction func stepperValueDidChange(_ sender: UIStepper) {
        // 1. The stepper's value IS the new number.
        let newValue = Int(sender.value)
        
        // 2. Format it and update the text field.
        numberTextField.text = converterModel.intToString(fromInt: newValue, base: currentBase)
        
        // 3. Re-trigger picker logic.
        let selectedRow = actionPickerView.selectedRow(inComponent: 0)
        pickerView(actionPickerView, didSelectRow: selectedRow, inComponent: 0)
    }
    
    @IBAction func shiftStepperDidChange(_ sender: UIStepper) {
        // COME BACK. Needed extra help with this one. Test and go to bed...
        // 1. Get the current integer value from the main text field.
            guard let intValue = converterModel.stringToInt(fromString: numberTextField.text ?? "", base: currentBase) else {
                generalResultLabel.text = "Error: Invalid base number"
                generalResultLabel.isHidden = false
                return
            }

            var resultValue: Int
            var shiftDirection: String

            // 2. Compare the stepper's new value to its last known value to find the direction.
            if sender.value > lastShiftValue {
                // The value increased, so the user pressed "+". Shift LEFT.
                resultValue = converterModel.shiftLeft(value: intValue)
                shiftDirection = "Left"
            } else {
                // The value decreased, so the user pressed "-". Shift RIGHT.
                resultValue = converterModel.shiftRight(value: intValue)
                shiftDirection = "Right"
            }

            // 3. IMPORTANT: Update the lastShiftValue to the new current value for the next tap.
            lastShiftValue = sender.value

            // 4. Format the result string and display it.
            let resultString = converterModel.intToString(fromInt: resultValue, base: currentBase)
            generalResultLabel.text = "Shift \(shiftDirection) Result: \(resultString)"
            generalResultLabel.isHidden = false
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        // When user taps the button, hide converterView and show welcomeView
        welcomeView.isHidden = false
        converterView.isHidden = true
        // Reset converterView when returning to the welcomeView.
        resetConverterState()
    }
    
    /// **Welcome Outlets and Actions
    @IBOutlet weak var welcomeView: UIView!
    
    @IBAction func enterButtonTapped(_ sender: UIButton) {
        // When user taps the button, hide welcomeView and show converterView
        welcomeView.isHidden = true
        converterView.isHidden = false
        // Reset converterView before going into the application.
        resetConverterState()
    }
    // -------------------------------------VIEW DID LOAD----------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        welcomeView.isHidden = false
        converterView.isHidden = true
        // Conform to the picker's protocol by implementing ALL the required methods:
        actionPickerView.delegate = self
        actionPickerView.dataSource = self
        // Conform to the mask's text field protocol by implementing ALL required methods:
        maskTextField.delegate = self
    }
    // -----------------------------------END VIEW DID LOAD--------------------------------
    
    // ----------------------------------COMPUTED PROPERTIES--------------------------------
    /// **pickerView options**
    let pickerData = [
        "Select an Action",
        "Display in Binary",
        "Display in Octal",
        "Display in Decimal",
        "Display in Hexadecimal",
        "Display in All Bases",
        "Bitwise Shift Left/Right",
        "Apply Mask"
        ]
    // Used to clean up Picker's didSelectRow.
    var currentBase: NumberBase {
        switch baseSegmentedControl.selectedSegmentIndex {
        case 0: return .binary
        case 1: return .hexadecimal
        case 2: return .octal
        case 3: return .decimal
        default: return .decimal // Most common number format so default it.
        }
    }
    // Property to detect which direction the stepper is moving: + adding or - subtracting.
    var lastShiftValue: Double = 0.0
    // -------------------------------END COMPUTED PROPERTIES------------------------------
    
    // -------------------------------FUNCTIONS AND SUCH-----------------------------------
    /// **Reset the converterView and all fields within it.**
    // Confused if this should be in model or controller.
    // Deals with VIEW stuff, so put in CONTROLLER.
    func resetConverterState() {
        /// Clear all text fields
        numberTextField.text = ""
        maskTextField.text = ""

        /// Reset all result labels and hide them.
        generalResultLabel.text = "Result" // Or just "". Come back to decide.
        binaryResultLabel.text = ""
        hexResultLabel.text = ""
        octalResultLabel.text = ""
        decimalResultLabel.text = ""
        /// Hide the result labels.
        generalResultLabel.isHidden = true
        binaryResultLabel.isHidden = true
        hexResultLabel.isHidden = true
        octalResultLabel.isHidden = true
        decimalResultLabel.isHidden = true

        /// Reset the segmented control to the first option.
        baseSegmentedControl.selectedSegmentIndex = 0

        /// Reset the steppers to zero.
        valueStepper.value = 0
        shiftStepper.value = 0

        /// Reset the picker view to the first row.
        actionPickerView.selectRow(0, inComponent: 0, animated: false)
        
        /// Reset my lastShift value recently added. Almost done....
        shiftStepper.value = 0
        lastShiftValue = 0.0
    }
    // Hides all the result labels.
    func hideAllResultLabels() {
        generalResultLabel.isHidden = true
        binaryResultLabel.isHidden = true
        octalResultLabel.isHidden = true
        decimalResultLabel.isHidden = true
        hexResultLabel.isHidden = true
    }
    // Shows all base labels except the general.
    func showAllBaseLabels() {
        generalResultLabel.isHidden = true // Hide the single label
        binaryResultLabel.isHidden = false
        octalResultLabel.isHidden = false
        decimalResultLabel.isHidden = false
        hexResultLabel.isHidden = false
    }
    // -----------------------------END FUNCTIONS AND SUCH---------------------------------

    // --------------------------PICKER VIEW REQUIRED METHODS------------------------------
    
    // Go back to in class app to see how to set up picker view...
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // This method tells the picker view how many rows are in our column.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count // Not .length dummy.
    }
    
    // Text for each row.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // This method is called whenever the user selects a row in the picker.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // COME BACK TO ADD LOGIC!! This is where the app will perform conversions, shifting, etc.
        // Hide all result labels and extra controls, get string input, and validate.
        hideAllResultLabels()
        shiftLabel.isHidden = true
        shiftStepper.isHidden = true
        maskLabel.isHidden = true
        maskTextField.isHidden = true
        // Use guard let to validate.
        guard let inputText = numberTextField.text, !inputText.isEmpty else {
                generalResultLabel.text = "Error: Input is empty"
                generalResultLabel.isHidden = false
                return
            }
        // Use model to convert string to integer form the current base. getting sleepy :(
        guard let intValue = converterModel.stringToInt(fromString: inputText, base: currentBase) else {
                generalResultLabel.text = "Error: Invalid number for base"
                generalResultLabel.isHidden = false
                return
            }
        
        // Round 1 had a million if/else statements. Try to clean it up with the switch statement.
        switch row {
            case 1: // Display in Binary.
                let resultString = converterModel.intToString(fromInt: intValue, base: .binary)
                generalResultLabel.text = "Binary: \(resultString)"
                generalResultLabel.isHidden = false
                
            case 2: // Display in Octal.
                let resultString = converterModel.intToString(fromInt: intValue, base: .octal)
                generalResultLabel.text = "Octal: \(resultString)"
                generalResultLabel.isHidden = false
                
            case 3: // Display in Decimal.
                let resultString = converterModel.intToString(fromInt: intValue, base: .decimal)
                generalResultLabel.text = "Decimal: \(resultString)"
                generalResultLabel.isHidden = false
                
            case 4: // Display in Hexadecimal.
                let resultString = converterModel.intToString(fromInt: intValue, base: .hexadecimal)
                generalResultLabel.text = "Hex: \(resultString)"
                generalResultLabel.isHidden = false
                
            case 5: // Display in All Bases.
                binaryResultLabel.text = "Bin: " + converterModel.intToString(fromInt: intValue, base: .binary)
                octalResultLabel.text = "Oct: " + converterModel.intToString(fromInt: intValue, base: .octal)
                decimalResultLabel.text = "Dec: " + converterModel.intToString(fromInt: intValue, base: .decimal)
                hexResultLabel.text = "Hex: " + converterModel.intToString(fromInt: intValue, base: .hexadecimal)
                showAllBaseLabels()
                
            case 6: // Bitwise Shift Left/Right.
                shiftLabel.isHidden = false
                shiftStepper.isHidden = false
                
            case 7: // Apply Mask.
                maskLabel.isHidden = false
                maskTextField.isHidden = false
                
            default:
                // This covers the "Select an Action" case, do nothing.
                break
            }
    }
    // -----------------------END PICKER VIEW REQUIRED METHODS------------------------------

    // ---------------------------TEXT FIELD METHODS (MASK)---------------------------------
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // This method gets called for BOTH text fields to check which one it is.
        if textField == maskTextField {
            // Create the new potential text after the change if needed. Asked the wizard.
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            // Perform the mask calculation with the updated text
            performMaskCalculation(maskString: updatedText)
        }

        return true // Allow the text change to happen
    }

    func performMaskCalculation(maskString: String) {
        // Get the main integer value.
        guard let intValue = converterModel.stringToInt(fromString: numberTextField.text ?? "", base: currentBase) else {
            generalResultLabel.text = "Error: Invalid input"
            generalResultLabel.isHidden = false
            return
        }

        // Get the mask integer value.
        guard let maskValue = converterModel.stringToInt(fromString: maskString, base: currentBase) else {
            generalResultLabel.text = "Error: Invalid mask"
            generalResultLabel.isHidden = false
            return
        }

        // Call the model and get the result.
        let resultValue = converterModel.applyMask(value: intValue, mask: maskValue)

        // Display the result.
        let resultString = converterModel.intToString(fromInt: resultValue, base: currentBase)
        generalResultLabel.text = "Mask Result: \(resultString)"
        generalResultLabel.isHidden = false
    }    // -------------------------END TEXT FIELD METHODS (MASK)---------------------------------
} // final closing bracket :)

