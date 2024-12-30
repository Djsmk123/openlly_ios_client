import Foundation

class HomeLocalSource {
    private let questionsKey = "savedQuestions" // Key to store questions in UserDefaults
    
    // Save a question, update if it already exists
    func saveQuestion(question: Question) {
        var savedQuestions = loadQuestions()
        
        // Check if question already exists based on id
        if let index = savedQuestions.firstIndex(where: { $0.id == question.id }) {
            // If exists, update the existing question
            savedQuestions[index] = question
        } else {
            // If not exists, add the new question
            savedQuestions.append(question)
        }
        
        // Save the updated array back to UserDefaults
        saveQuestions(questions: savedQuestions)
    }
    
    // Load all saved questions from UserDefaults
    func loadQuestions() -> [Question] {
        if let data = UserDefaults.standard.data(forKey: questionsKey),
           let savedQuestions = try? JSONDecoder().decode([Question].self, from: data) {
            return savedQuestions
        }
        return [] // Return empty array if no saved questions
    }
    
    // Save the questions array to UserDefaults
    private func saveQuestions(questions: [Question]) {
        if let encoded = try? JSONEncoder().encode(questions) {
            UserDefaults.standard.set(encoded, forKey: questionsKey)
        }
    }
}
