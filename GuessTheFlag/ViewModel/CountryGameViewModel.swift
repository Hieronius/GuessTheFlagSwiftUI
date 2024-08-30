import SwiftUI

final class CountryGameViewModel: ObservableObject {

	// MARK: - Published Properties

	/// User's score
	@Published var showingScore = false

	/// Until the game is not done do not display the user's score
	@Published var showingFinalScore = false

	/// A special property to display the final result of the game
	@Published var scoreTitle = ""

	@Published private(set) var score = 0
	@Published private(set) var questionCounter = 0
	@Published private(set) var correctAnswer = Int.random(in: 0...2)

	// MARK: - Public Properties

	/// Computed property to get the list of countries from our Model by using Init
	var currentCountries: [String] {
		countries
	}

	// MARK: - Private Properties

	private var countries: [String]


	// MARK: - Initialization
	
	/// Initialization of the Screen with Model Countries
	/// - Parameter countries: the pool of all possible countries
	init(countries: [String] = Countries.countries) {
		self.countries = countries
	}

	// MARK: - Public Methods

	/// Method to add or subtract score when the User taps a specific flag
	func flagTapped(_ number: Int) {
		if number == correctAnswer {
			scoreTitle = "Correct"
			score += 1
		} else {
			scoreTitle = "Wrong, it's a flag of \(countries[number])"
			if score > 0 {
				score -= 1
			}
		}
		showingScore = true
		questionCounter += 1

		if questionCounter == 8 {
			showingFinalScore = true
		}
	}

	/// Method for new iteration of the game stage
	func askQuestion() {
		countries.shuffle()
		correctAnswer = Int.random(in: 0...2)
	}

	/// Method to reset all game's properties and start a new game
	func resetGame() {
		score = 0
		questionCounter = 0
		askQuestion()
	}
}
