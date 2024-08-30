import SwiftUI

struct CountryGameView: View {

	// MARK: - Properties

	@StateObject private var viewModel = CountryGameViewModel()

	/// State for each flag to rotate with 3D animation if flag was tapped
	@State private var animationDegrees: [Double] = [0, 0, 0]

	/// Property to track selected flag
	@State private var selectedFlagIndex: Int? = nil

	// MARK: - Body

	var body: some View {

		// MARK: Background

		ZStack {
			RadialGradient(stops: [
				.init(color: Color(red: 0.1,
								   green: 0.2,
								   blue: 0.45),
					  location: 0.3),
				.init(color: Color(red: 0.76,
								   green: 0.15,
								   blue: 0.26),
					  location: 0.3)
			], 			   center: .top,
						   startRadius: 200,
						   endRadius: 400)
			.ignoresSafeArea()

			// MARK: Main Section of the Game

			VStack {
				Text("Guess the Flag")
					.font(.largeTitle.weight(.bold))
					.foregroundStyle(.white)

				Spacer()

				// MARK: Top Section of the Game

				VStack(spacing: 15) {

					VStack {
						Text("Tap the flag of")
							.font(.subheadline.weight(.heavy))
							.foregroundStyle(.secondary)

						Text(viewModel.currentCountries[viewModel.correctAnswer])
							.font(.largeTitle.weight(.semibold))
					}

					// MARK: Flags

					flagButtons()

				}
				.frame(maxWidth: .infinity)
				.padding(.vertical, 20)
				.background(.regularMaterial)
				.clipShape(.rect(cornerRadius: 20))

				// MARK: Bottom Section of the game

				Spacer()

				Text("Score: \(viewModel.score)")
					.foregroundStyle(.white)
					.font(.title.bold())

				Text("Current question - \(viewModel.questionCounter)/8")
					.foregroundStyle(.white)
					.font(.title)

				Spacer()
			}
			.padding()

			// MARK: Alerts

		}
		.alert(viewModel.scoreTitle, isPresented: $viewModel.showingScore) {
			Button("Continue", action: viewModel.askQuestion)
		} message: {
			Text("Your score is \(viewModel.score)")
		}

		.alert("Game over", isPresented: $viewModel.showingFinalScore) {
			Button("Start again", action: viewModel.resetGame)
		} message: {
			Text("Your final score is \(viewModel.score)")
		}
	}
}

extension CountryGameView {
	private func flagButtons() -> some View {
		ForEach(0..<3) { number in
			Button {
				withAnimation(.spring(response: 1, dampingFraction: 0.5)) {
					viewModel.flagTapped(number)
					animationDegrees[number] = 360
					selectedFlagIndex = number
				}
				Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
					withAnimation(.spring(response: 1, dampingFraction: 0.5)) {
						animationDegrees[number] = 0
						selectedFlagIndex = nil
					}
				}
			} label: {
				Image(viewModel.currentCountries[number])
					.resizable()
					.frame(width: 200, height: 100)
					.clipShape(Capsule())
					.rotation3DEffect(.degrees(animationDegrees[number]), axis: (x: 1, y: 0, z: 0))
					.opacity(selectedFlagIndex == nil || selectedFlagIndex == number ? 1.0 : 0.25)
					.scaleEffect(selectedFlagIndex == nil || selectedFlagIndex == number ? 1.0 : 0.8)
					.rotation3DEffect(
						.degrees(selectedFlagIndex == nil || selectedFlagIndex == number ? 360 : -360),
						axis: (x: 0, y: 1, z: 0)
					)
			}
		}
		.shadow(radius: 10)
	}
}

#Preview {
	CountryGameView()
}
