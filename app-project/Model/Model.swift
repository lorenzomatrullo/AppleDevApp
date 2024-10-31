import Foundation
import SwiftUI
import AVFoundation

// Model for a recipe
public struct RecipesList: Hashable {
    let recipeName: String
    let ingredients: String
    let numberOfSteps: Int
    let imageName: String
    let difficulty: String
    let timeToCook: Int
    let calories: Int
    let servings: Int
    let vegetarian: Bool
    let lactoseFree: Bool
    let glutenFree: Bool
    let steps: [RecipeStep] // Array of steps
    
    init(recipeName: String = "", ingredients: String = "", numberOfSteps: Int = 0, imageName: String = "", difficulty: String = "", timeToCook: Int = 0, calories: Int = 0, servings: Int = 1, vegetarian: Bool = false, lactoseFree: Bool = false, glutenFree: Bool = false ,steps: [RecipeStep] = []) {
        self.recipeName = recipeName
        self.ingredients = ingredients
        self.numberOfSteps = numberOfSteps
        self.imageName = imageName
        self.difficulty = difficulty
        self.timeToCook = timeToCook
        self.calories = calories
        self.servings = servings
        self.vegetarian = vegetarian
        self.lactoseFree = lactoseFree
        self.glutenFree = glutenFree
        self.steps = steps
    }
}

// Wrapper for steps variables
struct RecipeStep: Hashable {
    let step: String
    let imageName: String
    let description: String
    
    let usesTimer: Bool
    let timerTime: Int // time in seconds
}

public struct CookingState {
    var currentStep: Int
}

public enum HelpButtonState {
    case HOME_PAGE
    case MEAL_PAGE
    case STEP_PAGE
}

struct MealPageModel: Identifiable {
    var id = UUID()
    var meal: RecipesList
    var time: Int
    
    init(meal: RecipesList = RecipesList(), time: Int = 1) {
        self.meal = meal
        self.time = time
    }
}

// Main view model
class Model: ObservableObject {
    let meal: [RecipesList] = [
        RecipesList(
            recipeName: "Tomato Pasta",
            ingredients: "80g pennette pasta, 150g fresh tomatos, 1 tablespoon of olive oil, 1 garlic clove, 2 pinches of salt, few basil leaves, grated parmesan cheese",
            numberOfSteps: 4,
            imageName: "pasta",
            difficulty: "Easy",
            timeToCook: 20,
            calories: 500,
            servings: 1,
            vegetarian: true,
            steps: [
                RecipeStep(
                    step: "1. Preparare la pasta",
                    imageName: "pasta",
                    description: """
                    Let’s gather all the ingredients and place them on a clean, accessible table. When you’re ready with everything on the table, say ‘ready.’

                    Ingredients:
                    • Olive oil
                    • Garlic
                    • Canned tomato sauce
                    • Salt
                    • Pepper
                    • Fresh basil leaves (optional)
                    • Pasta (spaghetti, penne, or your choice)
                    • Grated Parmesan or Pecorino cheese (optional)
                    """,
                    usesTimer: false,
                    timerTime: 0
                ),
                
                RecipeStep(
                    step: "2. Preparare le patate",
                    imageName: "patate",
                    description: """
                    Place tomatoes in a large pot and cover with cold water. Bring just to a boil. Pour off water, and cover again with cold water. Peel the skin off tomatoes and cut into small pieces.
                    """,
                    usesTimer: false,
                    timerTime: 0
                ),
                
                RecipeStep(
                    step: "3. Cuocere la pasta",
                    imageName: "pasta",
                    description: "For this step we need a timer, so you can see how long it takes to cook the pasta. Say 'START' when you're ready to cook the pasta.",
                    usesTimer: true,
                    timerTime: 30
                ),
                
                RecipeStep(
                    step: "4. Combinare la pasta e la salsa",
                    imageName: "pasta",
                    description: """
                    Drain pasta; do not rinse in cold water. Toss with a bit of olive oil, then mix into the sauce.
                    """,
                    usesTimer: false,
                    timerTime: 0
                ),
            ]
        ),
        
        RecipesList(
            recipeName: "Pizza Salsiccia e Friarielli",
            ingredients: "salsiccia, friarielli",
            numberOfSteps: 4,
            imageName: "pizza",
            difficulty: "Medium",
            timeToCook: 8,
            glutenFree: true,
            steps: [
                RecipeStep(
                    step: "1. Preparare la pasta",
                    imageName: "pasta",
                    description: """
                    Let’s gather all the ingredients and place them on a clean, accessible table. When you’re ready with everything on the table, say ‘ready.’

                    Ingredients:
                    • 2 Heck 97% Sausages
                    • 1 260g Neapolitan Dough ball
                    • 80g Fior Di Latte Mozzarella
                    • 10g Smoked Mozzarella (scamorza)
                    • A pinch of grated Hard Cheese
                    • 2 handfuls of cooked Friarielli
                    """,
                    usesTimer: false,
                    timerTime: 0
                ),
                
                RecipeStep(
                    step: "2. Preparare le patate",
                    imageName: "patate",
                    description: """
                    Place tomatoes in a large pot and cover with cold water. Bring just to a boil. Pour off water, and cover again with cold water. Peel the skin off tomatoes and cut into small pieces.
                    """,
                    usesTimer: false,
                    timerTime: 0
                ),
                
                RecipeStep(
                    step: "3. Cuocere la pasta",
                    imageName: "pasta",
                    description: """
                    Meanwhile, heat olive oil in a large skillet or pan, ensuring there is enough to cover the bottom of the pan. Sauté garlic until opaque but not browned. Stir in tomato paste. Immediately stir in the tomatoes, salt, and pepper. Reduce heat, and simmer until pasta is ready, adding basil at the end.
                    """,
                    usesTimer: false,
                    timerTime: 0
                ),
                
                RecipeStep(
                    step: "4. Combinare la pasta e la salsa",
                    imageName: "pasta",
                    description: """
                    Drain pasta; do not rinse in cold water. Toss with a bit of olive oil, then mix into the sauce.
                    """,
                    usesTimer: false,
                    timerTime: 0
                ),
            ]
        ),
    ]
    
    
    
    @Published var mealPage = MealPageModel()
    @Published var displayingMealPage = false
    @Published var followNavigationLink = false
    
    @Published var displayTabBar = true
    @Published var tabBarChanged = true
    @Published var tabViewSelectedIndex = Int.max {
        didSet {
            tabBarChanged = true
        }
    }
}

public func FormatTimeRemaining(_ seconds: Int) -> String {
    let minutes = seconds / 60
    let remainingSeconds = seconds % 60
    return String(format: "%02d:%02d", minutes, remainingSeconds)
}

public func SpeakMessage(str: String, speechSynthesizer: AVSpeechSynthesizer) {
    let voice = AVSpeechSynthesisVoice(language: "en-US")
    let msgUtterance = AVSpeechUtterance(string: str)
    msgUtterance.voice = voice
    speechSynthesizer.speak(msgUtterance)
}

public func HelpButtonPressed(status : HelpButtonState, synth: AVSpeechSynthesizer, meal : RecipesList?, cookingState : CookingState?) {

    switch(status)
    {
        case HelpButtonState.HOME_PAGE:
        SpeakMessage(str: "You are currently in the 'Home Page', you can select an option between: 'Pasta', 'Pizza', to have more details on the Recipe.", speechSynthesizer: synth)
        break
        
        case HelpButtonState.MEAL_PAGE:
        if let meal = meal {
            // Use meal safely here
            SpeakMessage(str: "You are currently in the 'Meal Page' and you're viewing the recipe for \(meal.recipeName). You can say 'Read again', to read the recipe again. You can say 'Start', to start cooking the recipe. You can say 'Back', to go back to the 'Home Page'.", speechSynthesizer: synth)
            }
            else {
                debugPrint("Meal is nil")
            }
        

        break
        case HelpButtonState.STEP_PAGE:
        if let meal = meal, let cookingState = cookingState {
            // Use meal and cookingState safely here
            SpeakMessage(str: "You are currently in the 'Step Page' for. \(meal.recipeName). You are at Step \(cookingState.currentStep+1) out of \(meal.numberOfSteps). You can say 'Read again', to read the step again. You can say 'Next', to go to the next step. You can say 'Previous', to go on the previous step.", speechSynthesizer: synth)
        }
        else {
            debugPrint("Meal or cookingState is nil")
        }
        break
    }
}
