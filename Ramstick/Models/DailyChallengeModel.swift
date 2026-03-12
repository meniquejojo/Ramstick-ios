
import SwiftUI
import Combine

// MARK: - Daily Challenge State
class DailyChallengeState: ObservableObject {

    // ── Streak
    @Published var currentStreak: Int = 0 {
        didSet { UserDefaults.standard.set(currentStreak, forKey: "dc_streak") }
    }
    @Published var longestStreak: Int = 0 {
        didSet { UserDefaults.standard.set(longestStreak, forKey: "dc_longest") }
    }

    // ── Completion tracking
    @Published var lastCompletedDateString: String = "" {
        didSet { UserDefaults.standard.set(lastCompletedDateString, forKey: "dc_last_date") }
    }
    @Published var completedToday: Bool = false
    @Published var todayEarned: Int = 0 {
        didSet { UserDefaults.standard.set(todayEarned, forKey: "dc_today_earned") }
    }

    // ── Total lifetime
    @Published var totalChallengesCompleted: Int = 0 {
        didSet { UserDefaults.standard.set(totalChallengesCompleted, forKey: "dc_total") }
    }

    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    var todayString: String { dateFormatter.string(from: Date()) }

    init() {
        currentStreak              = UserDefaults.standard.integer(forKey: "dc_streak")
        longestStreak              = UserDefaults.standard.integer(forKey: "dc_longest")
        lastCompletedDateString    = UserDefaults.standard.string(forKey: "dc_last_date") ?? ""
        totalChallengesCompleted   = UserDefaults.standard.integer(forKey: "dc_total")
        todayEarned                = UserDefaults.standard.integer(forKey: "dc_today_earned")
        refreshCompletionStatus()
    }

    func refreshCompletionStatus() {
        completedToday = (lastCompletedDateString == todayString)

        // Break streak if a day was skipped
        if !completedToday, let last = dateFormatter.date(from: lastCompletedDateString) {
            let days = Calendar.current.dateComponents([.day], from: last, to: Date()).day ?? 0
            if days > 1 { currentStreak = 0 }
        }
    }

    func markCompleted(earned: Int) {
        guard !completedToday else { return }
        lastCompletedDateString  = todayString
        completedToday           = true
        currentStreak           += 1
        totalChallengesCompleted += 1
        todayEarned              = earned
        if currentStreak > longestStreak { longestStreak = currentStreak }
    }

    // Streak reward multiplier: 1x → 3x based on streak length
    var streakMultiplier: Int {
        switch currentStreak {
        case 0...2:  return 1
        case 3...6:  return 2
        case 7...13: return 3
        default:     return 4
        }
    }

    var streakBadge: String {
        switch currentStreak {
        case 0...2:  return "🌱"
        case 3...6:  return "🔥"
        case 7...13: return "⚡️"
        default:     return "🏆"
        }
    }

    var nextRewardAt: Int {
        switch currentStreak {
        case 0...2:  return 3
        case 3...6:  return 7
        case 7...13: return 14
        default:     return currentStreak + 7
        }
    }
}

// MARK: - Daily Challenge Question Pool
// Questions rotate by day-of-year so everyone gets the same question each day
struct DailyChallengeBank {

    static func todaysChallenge() -> DailyChallenge {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let pool = allChallenges
        let index = (dayOfYear - 1) % pool.count
        return pool[index]
    }

    static let allChallenges: [DailyChallenge] = [

        // ── Math
        DailyChallenge(
            id: "dc_001", category: .math,
            question: "A student spends $45 on textbooks and $23 on supplies. If they started with $100, how much do they have left?",
            options: ["$32", "$42", "$22", "$38"],
            correctIndex: 0,
            explanation: "$100 – $45 – $23 = $32. Always budget for supplies!",
            baseReward: 15
        ),
        DailyChallenge(
            id: "dc_002", category: .math,
            question: "Your GPA is 3.2 after 3 semesters. What GPA do you need in semester 4 to reach a 3.5 average?",
            options: ["3.8", "4.0", "4.1", "3.9"],
            correctIndex: 2,
            explanation: "(3.2 × 3 + x) / 4 = 3.5 → x = 4.1. Some courses allow extra credit!",
            baseReward: 20
        ),
        DailyChallenge(
            id: "dc_003", category: .math,
            question: "A scholarship covers 60% of $18,000 tuition. How much do you still owe?",
            options: ["$7,200", "$10,800", "$8,000", "$6,500"],
            correctIndex: 0,
            explanation: "40% of $18,000 = $7,200. Always apply for multiple scholarships!",
            baseReward: 15
        ),
        DailyChallenge(
            id: "dc_004", category: .math,
            question: "If you study 2.5 hours a day for 5 days, how many total hours is that?",
            options: ["10", "11.5", "12", "12.5"],
            correctIndex: 3,
            explanation: "2.5 × 5 = 12.5 hours. Consistent daily study beats cramming.",
            baseReward: 10
        ),
        DailyChallenge(
            id: "dc_005", category: .math,
            question: "You earn $12/hr working 15 hours a week. How much do you earn in 4 weeks?",
            options: ["$620", "$720", "$680", "$740"],
            correctIndex: 1,
            explanation: "$12 × 15 × 4 = $720. Part-time work adds up fast!",
            baseReward: 15
        ),

        // ── Financial Literacy
        DailyChallenge(
            id: "dc_006", category: .finance,
            question: "What does FAFSA stand for?",
            options: [
                "Free Application for Federal Student Aid",
                "Federal Aid for Student Applications",
                "Free Annual Financial Student Assistance",
                "Federal Application for Student Assistance"
            ],
            correctIndex: 0,
            explanation: "FAFSA opens October 1st each year. Always file early for maximum aid!",
            baseReward: 15
        ),
        DailyChallenge(
            id: "dc_007", category: .finance,
            question: "Which credit score range is considered 'Good' by most lenders?",
            options: ["300–579", "580–669", "670–739", "740–799"],
            correctIndex: 2,
            explanation: "670–739 is 'Good'. Building credit in college sets you up for life.",
            baseReward: 15
        ),
        DailyChallenge(
            id: "dc_008", category: .finance,
            question: "What is compound interest?",
            options: [
                "Interest paid only on the original amount",
                "Interest earned on both principal and accumulated interest",
                "A fixed monthly fee from your bank",
                "Interest that decreases over time"
            ],
            correctIndex: 1,
            explanation: "Compound interest grows your savings exponentially. Start saving early!",
            baseReward: 20
        ),
        DailyChallenge(
            id: "dc_009", category: .finance,
            question: "Which type of student loan has interest paid by the government while you're in school?",
            options: ["Unsubsidized", "PLUS Loan", "Subsidized", "Private"],
            correctIndex: 2,
            explanation: "Subsidized loans save you money — the gov't covers interest during school.",
            baseReward: 15
        ),
        DailyChallenge(
            id: "dc_010", category: .finance,
            question: "The 50/30/20 budgeting rule splits income into needs, wants, and what?",
            options: ["Investments", "Savings", "Debt repayment", "Emergency fund"],
            correctIndex: 1,
            explanation: "50% needs, 30% wants, 20% savings. A simple rule to build wealth.",
            baseReward: 15
        ),

        // ── HT History & Culture
        DailyChallenge(
            id: "dc_011", category: .htHistory,
            question: "Huston-Tillotson University was formed by the merger of two schools. Which year did the merger officially happen?",
            options: ["1945", "1952", "1958", "1963"],
            correctIndex: 1,
            explanation: "Samuel Huston College and Tillotson College merged in 1952 to form HT.",
            baseReward: 20
        ),
        DailyChallenge(
            id: "dc_012", category: .htHistory,
            question: "HT is affiliated with which two religious denominations?",
            options: [
                "Baptist & Catholic",
                "Methodist & Presbyterian",
                "United Methodist Church & United Church of Christ",
                "Lutheran & Episcopal"
            ],
            correctIndex: 2,
            explanation: "HT's dual affiliation reflects its merger heritage from both founding schools.",
            baseReward: 20
        ),
        DailyChallenge(
            id: "dc_013", category: .htHistory,
            question: "What is the name of HT's official student newspaper?",
            options: ["The Rambler Report", "The HT Voice", "The Blue & Gold", "The Torch"],
            correctIndex: 3,
            explanation: "The Torch has been a key student voice at HT for decades.",
            baseReward: 15
        ),
        DailyChallenge(
            id: "dc_014", category: .htHistory,
            question: "HT's campus is located in which Austin neighborhood?",
            options: ["East Austin", "South Congress", "Hyde Park", "Mueller"],
            correctIndex: 0,
            explanation: "HT sits in historic East Austin, a culturally rich community.",
            baseReward: 15
        ),

        // ── Career & Professional
        DailyChallenge(
            id: "dc_015", category: .career,
            question: "What is the purpose of a cover letter?",
            options: [
                "To list your work experience in detail",
                "To introduce yourself and explain why you're the best fit",
                "To provide references from professors",
                "To summarize your GPA"
            ],
            correctIndex: 1,
            explanation: "A great cover letter tells your story. Tailor it for every application!",
            baseReward: 15
        ),
        DailyChallenge(
            id: "dc_016", category: .career,
            question: "What does networking mean in a professional context?",
            options: [
                "Setting up computer networks",
                "Building relationships with professionals in your field",
                "Applying to multiple jobs at once",
                "Using LinkedIn to find job listings"
            ],
            correctIndex: 1,
            explanation: "Over 70% of jobs are filled through networking. Build those connections!",
            baseReward: 15
        ),
        DailyChallenge(
            id: "dc_017", category: .career,
            question: "How long should a college student's resume typically be?",
            options: ["3 pages", "2 pages", "1 page", "As long as needed"],
            correctIndex: 2,
            explanation: "Keep it to 1 page as a student. Concise and impactful wins.",
            baseReward: 10
        ),

        // ── World Knowledge
        DailyChallenge(
            id: "dc_018", category: .world,
            question: "Which African country was never colonized by a European power?",
            options: ["Ghana", "Ethiopia", "Nigeria", "Kenya"],
            correctIndex: 1,
            explanation: "Ethiopia successfully resisted colonization, defeating Italy at the Battle of Adwa in 1896.",
            baseReward: 20
        ),
        DailyChallenge(
            id: "dc_019", category: .world,
            question: "What year was the NAACP founded?",
            options: ["1905", "1909", "1915", "1920"],
            correctIndex: 1,
            explanation: "The NAACP was founded February 12, 1909. Its work continues today.",
            baseReward: 20
        ),
        DailyChallenge(
            id: "dc_020", category: .world,
            question: "Which HBCU is the oldest in the United States?",
            options: ["Howard University", "Spelman College", "Cheyney University", "Morehouse College"],
            correctIndex: 2,
            explanation: "Cheyney University of Pennsylvania was founded in 1837, making it the oldest HBCU.",
            baseReward: 20
        ),
    ]
}

// MARK: - Daily Challenge Type
struct DailyChallenge: Identifiable {
    let id: String
    let category: ChallengeCategory
    let question: String
    let options: [String]
    let correctIndex: Int
    let explanation: String
    let baseReward: Int
}

enum ChallengeCategory: String {
    case math       = "Math 🔢"
    case finance    = "Finance 💰"
    case htHistory  = "HT History 🎓"
    case career     = "Career 💼"
    case world      = "World Knowledge 🌍"

    var color: Color {
        switch self {
        case .math:      return Color.cfMaroon
        case .finance:   return Color.cfGold
        case .htHistory: return Color.cfGreen
        case .career:    return Color.blue
        case .world:     return Color.purple
        }
    }
    var icon: String {
        switch self {
        case .math:      return "function"
        case .finance:   return "dollarsign.circle.fill"
        case .htHistory: return "building.columns.fill"
        case .career:    return "briefcase.fill"
        case .world:     return "globe.americas.fill"
        }
    }
}
