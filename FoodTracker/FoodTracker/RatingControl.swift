//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Sara Topic on 07/01/2018.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {

    
    //MARK: Properties
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    //only the RatingControl class can access these buttons
    private var ratingButtons = [UIButton]()
    
    //not private bc we need to be able to read and write to it from outside this class
    var rating = 0 {
        didSet {
            // property observer calls this when the user changes the rating
            updateButtonSelectionStates()
        }
    }
    
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Button Action
    @objc func ratingButtonTapped(button: UIButton) {
        // tries to find the selected button in the array of buttons
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        // Calculate the rating of the selected button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            // If the selected star represents the current rating, reset the rating to 0.
            rating = 0
        } else {
            // Otherwise set the rating to the selected star
            rating = selectedRating
        }
    }
    
    //MARK: Private Methods
    private func setupButtons() {
        
        // clear any existing buttons
        for button in ratingButtons {
            //removes the button from the list of views managed by the stack view aka says you no longer need to calculate this button's size and position
            removeArrangedSubview(button)
            //removes button from stack view
            button.removeFromSuperview()
        }
        //clears the ratingButtons array
        ratingButtons.removeAll()
        
        // Load Button Images
        let bundle = Bundle(for: type(of: self))
        
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        
        let emptyStar = UIImage(named:"emptyStar", in: bundle, compatibleWith: self.traitCollection)
        
        let highlightedStar = UIImage(named:"highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for index in 0..<starCount {
        
            // Create the button
            let button = UIButton()
            
            
            // Set the button images
            
            //use an empty star for the normal state (default)
            button.setImage(emptyStar, for: .normal)
            
            //use a filled star for selected state
            button.setImage(filledStar, for: .selected)
            
            // When the user touches the button and it is not selected, show the highlighted star
            button.setImage(highlightedStar, for: .highlighted)
            
            //when the user touches the button and it is selected, show the highlighted star
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            // Add constraints
            
            //disables button's automatically generated contraints
            button.translatesAutoresizingMaskIntoConstraints = false
            
            //definte the button's height and width
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // Set the accessibility label
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            // Setup the button action
            // attaching the ratingButtonTapped action method to the button object, which gets triggered when a .TouchDown event occurs (the button is pressed)
            button.addTarget(self, action:
                #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Add the button to the stack
            addArrangedSubview(button)
            
            // Add the new button to the rating button array
            ratingButtons.append(button)
        }
        
        updateButtonSelectionStates()

    }
    
    //updates the button's appearance
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index < rating
            // so only set it selected if index of the button is less than the rating the user selected
            // Set the hint string for the currently selected star
            let hintString: String?
            if rating == index + 1 { // the current rating has been tapped again
                hintString = "Tap to reset the rating to zero."
            } else {
                hintString = nil //effect already adequately described by label
            }
            
            // Calculate the value string
            let valueString: String
            switch (rating) {
            case 0:
                valueString = "No rating set."
            // since 1 isnt plural
            case 1:
                valueString = "1 star set."
            // calculate value string using interpolation
            default:
                valueString = "\(rating) stars set."
            }
            
            // Assign the hint string and value string
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }
}
