
import SwiftUI

// MARK: - Category
enum QuizCategory: String, CaseIterable, Identifiable {
    case math    = "Math"
    case finance = "Finance"
    case ht      = "HT Facts"
    case world   = "World Knowledge"
    case career  = "Career"

    var id: String { rawValue }
    var emoji: String {
        switch self {
        case .math:    return "🔢"
        case .finance: return "💰"
        case .ht:      return "🏛️"
        case .world:   return "🌍"
        case .career:  return "💼"
        }
    }
    var color: Color {
        switch self {
        case .math:    return Color.blue
        case .finance: return Color.cfGold
        case .ht:      return Color.cfMaroon
        case .world:   return Color.cfGreen
        case .career:  return Color.purple
        }
    }
    // Fun facts only show for HT and World Knowledge
    var hasFunFacts: Bool { self == .ht || self == .world }
}

// MARK: - Model
struct HTQuizQuestion {
    let question:     String
    let answers:      [String]
    let correctIndex: Int
    let category:     QuizCategory
    let funFact:      String?       // nil for math/finance/career
    let funFactEmoji: String?
}

enum HTQuizPhase {
    case pickCategory
    case loading
    case answering
    case showingFunFact(correct: Bool)
    case finished
}

// MARK: - Question Bank
private let htQuizBank: [HTQuizQuestion] = [

    // ── MATH ──────────────────────────────────────────────
    HTQuizQuestion(question: "What is the square root of 144?",
                   answers: ["10","12","14","16"], correctIndex: 1,
                   category: .math, funFact: nil, funFactEmoji: nil),

    HTQuizQuestion(question: "If you invest $1,000 at 10% compound interest annually, how much after 2 years?",
                   answers: ["$1,100","$1,200","$1,210","$1,250"], correctIndex: 2,
                   category: .math, funFact: nil, funFactEmoji: nil),

    HTQuizQuestion(question: "What percentage of 200 is 50?",
                   answers: ["15%","20%","25%","30%"], correctIndex: 2,
                   category: .math, funFact: nil, funFactEmoji: nil),

    HTQuizQuestion(question: "A store offers 30% off an $80 item. What is the sale price?",
                   answers: ["$52","$54","$56","$60"], correctIndex: 2,
                   category: .math, funFact: nil, funFactEmoji: nil),

    HTQuizQuestion(question: "Solve for x: 3x + 9 = 27",
                   answers: ["4","5","6","7"], correctIndex: 2,
                   category: .math, funFact: nil, funFactEmoji: nil),

    HTQuizQuestion(question: "What is 15% of $240?",
                   answers: ["$30","$36","$40","$48"], correctIndex: 1,
                   category: .math, funFact: nil, funFactEmoji: nil),

    HTQuizQuestion(question: "If a triangle has a base of 10 and height of 6, what is its area?",
                   answers: ["30","40","60","16"], correctIndex: 0,
                   category: .math, funFact: nil, funFactEmoji: nil),

    HTQuizQuestion(question: "What is 2 to the power of 8?",
                   answers: ["128","256","512","64"], correctIndex: 1,
                   category: .math, funFact: nil, funFactEmoji: nil),

    // ── FINANCE ───────────────────────────────────────────
    HTQuizQuestion(question: "What does APR stand for?",
                   answers: ["Annual Payment Rate","Annual Percentage Rate","Applied Prime Rate","Adjusted Pay Rate"], correctIndex: 1,
                   category: .finance, funFact: nil, funFactEmoji: nil),

    HTQuizQuestion(question: "What is the US credit score range?",
                   answers: ["100–500","300–850","0–1000","200–750"], correctIndex: 1,
                   category: .finance, funFact: nil, funFactEmoji: nil),

    HTQuizQuestion(question: "What does FAFSA stand for?",
                   answers: ["Federal Application For Student Aid","Free Application for Federal Student Aid","Financial Aid For Student Applicants","Federal Association For Student Advancement"], correctIndex: 1,
                   category: .finance, funFact: nil, funFactEmoji: nil),

    HTQuizQuestion(question: "Which type of account typically earns the most interest?",
                   answers: ["Checking account","Savings account","High-yield savings account","Money market account"], correctIndex: 2,
                   category: .finance, funFact: nil, funFactEmoji: nil),

    HTQuizQuestion(question: "What is a 401(k)?",
                   answers: ["A type of credit card","An employer retirement savings plan","A student loan program","A government tax form"], correctIndex: 1,
                   category: .finance, funFact: nil, funFactEmoji: nil),

    HTQuizQuestion(question: "If you earn $15/hr and work 20 hours a week, what is your gross monthly income (4 weeks)?",
                   answers: ["$900","$1,000","$1,200","$1,500"], correctIndex: 2,
                   category: .finance, funFact: nil, funFactEmoji: nil),

    HTQuizQuestion(question: "What credit score is generally considered 'good'?",
                   answers: ["550–600","620–659","670–739","800+"], correctIndex: 2,
                   category: .finance, funFact: nil, funFactEmoji: nil),

    HTQuizQuestion(question: "What is the 50/30/20 budgeting rule?",
                   answers: ["50% savings, 30% bills, 20% fun","50% needs, 30% wants, 20% savings","50% fun, 30% savings, 20% needs","50% bills, 30% savings, 20% food"], correctIndex: 1,
                   category: .finance, funFact: nil, funFactEmoji: nil),

    // ── HT FACTS (with fun facts) ─────────────────────────
    HTQuizQuestion(question: "What year was Huston-Tillotson University founded?",
                   answers: ["1875","1900","1952","1865"], correctIndex: 0,
                   category: .ht,
                   funFact: "HT was formed by merging Samuel Huston College (1900) and Tillotson College (1877) — making it one of the oldest HBCUs in Texas with roots going back nearly 150 years!",
                   funFactEmoji: "🏛️"),

    HTQuizQuestion(question: "What are HT's official school colors?",
                   answers: ["Blue and Gold","Maroon and Gold","Green and Gold","Red and Black"], correctIndex: 1,
                   category: .ht,
                   funFact: "Maroon represents strength and perseverance — a color deeply tied to HBCU culture. Howard, Morehouse, and Texas Southern also feature maroon in their identity.",
                   funFactEmoji: "🎨"),

    HTQuizQuestion(question: "What is HT's athletic team name?",
                   answers: ["Eagles","Tigers","Ramblers","Rams"], correctIndex: 3,
                   category: .ht,
                   funFact: "The Ramblers name reflects a spirit of movement and determination. HT competes in the Red River Athletic Conference (RRAC) of the NAIA.",
                   funFactEmoji: "🏀"),

    HTQuizQuestion(question: "Where is Huston-Tillotson University located?",
                   answers: ["Dallas, TX","Houston, TX","East Austin, TX","San Antonio, TX"], correctIndex: 2,
                   category: .ht,
                   funFact: "HT sits in East Austin — one of the most historically Black neighborhoods in Texas. The campus has been a cornerstone of that community for generations.",
                   funFactEmoji: "📍"),

    HTQuizQuestion(question: "HT is affiliated with which two religious denominations?",
                   answers: ["Baptist and Catholic","Methodist and Presbyterian","United Methodist and United Church of Christ","Pentecostal and Lutheran"], correctIndex: 2,
                   category: .ht,
                   funFact: "The merger of a Methodist school and a Congregationalist school created HT's unique dual affiliation — a rare pairing that reflects the university's inclusive values.",
                   funFactEmoji: "✝️"),

    HTQuizQuestion(question: "What is HT's motto?",
                   answers: ["Truth and Service","Excellence and Integrity","Leadership Through Service","In Union,Strength"], correctIndex: 3,
                   category: .ht,
                   funFact: "HT's holistic philosophy means developing students academically, spiritually, and socially — reflecting the HBCU tradition of producing leaders who serve their communities.",
                   funFactEmoji: "📜"),

    HTQuizQuestion(question: "Approximately how many students attend HT?",
                   answers: ["500–800","900–1,200","1,500–2,000","2,500–3,000"], correctIndex: 1,
                   category: .ht,
                   funFact: "HT's small size is a feature, not a bug. Smaller class sizes mean more direct access to professors and a tight-knit campus community that big universities can't replicate.",
                   funFactEmoji: "🎓"),

    HTQuizQuestion(question: "What conference does HT compete in athletically?",
                   answers: ["SWAC","MEAC","RRAC (NAIA)","NCAA Division II"], correctIndex: 2,
                   category: .ht,
                   funFact: "The Red River Athletic Conference spans Texas and surrounding states. HT competes in sports including basketball, cross country, soccer, and volleyball.",
                   funFactEmoji: "🏅"),

    // ── WORLD KNOWLEDGE (with fun facts) ──────────────────
    HTQuizQuestion(question: "Which country has the largest economy (nominal GDP)?",
                   answers: ["China","Japan","Germany","United States"], correctIndex: 3,
                   category: .world,
                   funFact: "The US GDP is over $27 trillion — larger than the next three countries combined. By purchasing power parity, China has actually overtaken the US since 2016.",
                   funFactEmoji: "🌍"),

    HTQuizQuestion(question: "What is the capital of Australia?",
                   answers: ["Sydney","Melbourne","Canberra","Brisbane"], correctIndex: 2,
                   category: .world,
                   funFact: "Canberra was purpose-built in 1913 because Sydney and Melbourne couldn't agree on which should be capital — so they split the difference and built a brand new city between them!",
                   funFactEmoji: "🇦🇺"),

    HTQuizQuestion(question: "How many bones are in the adult human body?",
                   answers: ["186","206","226","256"], correctIndex: 1,
                   category: .world,
                   funFact: "Babies are born with ~270 bones. Many fuse as you grow. The smallest bone is the stirrup in your ear — just 3mm long!",
                   funFactEmoji: "🦴"),

    HTQuizQuestion(question: "Which planet is known as the Red Planet?",
                   answers: ["Venus","Jupiter","Mars","Saturn"], correctIndex: 2,
                   category: .world,
                   funFact: "Mars gets its red color from iron oxide (rust) on its surface. NASA has been sending rovers there since 1997 — and plans to send humans in the 2030s.",
                   funFactEmoji: "🔴"),

    HTQuizQuestion(question: "Who wrote 'I Have a Dream'?",
                   answers: ["Malcolm X","Thurgood Marshall","Martin Luther King Jr.","Frederick Douglass"], correctIndex: 2,
                   category: .world,
                   funFact: "The 'I Have a Dream' speech was largely improvised. MLK had given a version of it before, but Gospel singer Mahalia Jackson called out 'Tell them about the dream!' — and he went off script.",
                   funFactEmoji: "✊"),

    HTQuizQuestion(question: "What is the largest ocean on Earth?",
                   answers: ["Atlantic","Indian","Arctic","Pacific"], correctIndex: 3,
                   category: .world,
                   funFact: "The Pacific Ocean covers more area than all of Earth's land combined. It holds about half of the world's water and contains the deepest point on Earth — the Mariana Trench at ~36,000 feet.",
                   funFactEmoji: "🌊"),

    HTQuizQuestion(question: "In what year did the Berlin Wall fall?",
                   answers: ["1985","1987","1989","1991"], correctIndex: 2,
                   category: .world,
                   funFact: "The Berlin Wall fell on November 9, 1989 — a date that also marks Kristallnacht (1938). Germans have a complicated relationship with that date, but 1989 is widely celebrated as a moment of liberation.",
                   funFactEmoji: "🧱"),

    HTQuizQuestion(question: "Which element has the chemical symbol 'Au'?",
                   answers: ["Silver","Gold","Aluminum","Argon"], correctIndex: 1,
                   category: .world,
                   funFact: "Au comes from 'Aurum,' the Latin word for gold. Gold is so chemically stable it never rusts or corrodes — which is why ancient gold artifacts still shine thousands of years later.",
                   funFactEmoji: "🥇"),

    // ── CAREER ────────────────────────────────────────────
    HTQuizQuestion(question: "What does 'networking' mean professionally?",
                   answers: ["Setting up computer systems","Building relationships with professionals","Applying for jobs online","Creating a LinkedIn profile"], correctIndex: 1,
                   category: .career, funFact: nil, funFactEmoji: nil),

    HTQuizQuestion(question: "What should you NOT include on a modern US resume?",
                   answers: ["Work experience","Your photo and age","Education","Skills"], correctIndex: 1,
                   category: .career, funFact: nil, funFactEmoji: nil),

    HTQuizQuestion(question: "How long should an entry-level resume typically be?",
                   answers: ["Half a page","1 page","2 pages","3+ pages"], correctIndex: 1,
                   category: .career, funFact: nil, funFactEmoji: nil),

    HTQuizQuestion(question: "What is the purpose of a cover letter?",
                   answers: ["List your references","Repeat your resume word for word","Tell your story and why you want the specific role","Summarize your GPA"], correctIndex: 2,
                   category: .career, funFact: nil, funFactEmoji: nil),

    HTQuizQuestion(question: "What does ROI stand for in business?",
                   answers: ["Rate of Income","Return on Investment","Revenue Over Inflation","Record of Interest"], correctIndex: 1,
                   category: .career, funFact: nil, funFactEmoji: nil),

    HTQuizQuestion(question: "How soon should you send a thank-you email after a job interview?",
                   answers: ["Same day or within 24 hours","Within 1 week","Only if you want the job","After you receive an offer"], correctIndex: 0,
                   category: .career, funFact: nil, funFactEmoji: nil),

    HTQuizQuestion(question: "What is an 'elevator pitch'?",
                   answers: ["A pitch delivered in an elevator","A 30–60 second professional introduction","A sales pitch for a product","A cover letter summary"], correctIndex: 1,
                   category: .career, funFact: nil, funFactEmoji: nil),

    HTQuizQuestion(question: "Which skill is most valued by employers across all industries?",
                   answers: ["Coding","Communication","Graphic design","Accounting"], correctIndex: 1,
                   category: .career, funFact: nil, funFactEmoji: nil),
]

// MARK: - View
struct QuizGameView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss

    @State private var selectedCategory: QuizCategory? = nil
    @State private var shuffled:          [HTQuizQuestion] = []
    @State private var currentIndex:      Int = 0
    @State private var selectedAnswer:    Int? = nil
    @State private var phase:             HTQuizPhase = .pickCategory
    @State private var score:             Int = 0
    @State private var coinsEarned:       Int = 0
    @State private var streak:            Int = 0
    @State private var bestStreak:        Int = 0
    @State private var saved:             Bool = false
    @State private var factScale:         CGFloat = 0.85
    @State private var factOpacity:       Double = 0

    private let totalQ = 8

    private var currentQuestion: HTQuizQuestion? {
        guard !shuffled.isEmpty, currentIndex < shuffled.count else { return nil }
        return shuffled[currentIndex]
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.08, green: 0.04, blue: 0.12),
                         Color(red: 0.04, green: 0.02, blue: 0.09)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                switch phase {
                case .pickCategory:
                    categoryPicker
                case .loading:
                    Spacer()
                    ProgressView().progressViewStyle(.circular).tint(Color.white)
                    Spacer()
                case .finished:
                    hudBar
                    resultsView
                default:
                    hudBar
                    if let q = currentQuestion {
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 18) {
                                questionCard(q)
                                answersStack(q)
                                if case .showingFunFact = phase {
                                    if q.category.hasFunFacts, let _ = q.funFact {
                                        funFactCard(q)
                                            .scaleEffect(factScale)
                                            .opacity(factOpacity)
                                    } else {
                                        // No fun fact for this category — just show result banner
                                        resultOnlyBanner(q)
                                            .scaleEffect(factScale)
                                            .opacity(factOpacity)
                                    }
                                    nextBtn.opacity(factOpacity)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                            .padding(.bottom, 32)
                        }
                    }
                }
            }
        }
    }

    // MARK: Category Picker
    private var categoryPicker: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(Font.system(size: 24))
                        .foregroundColor((Color.white as Color).opacity(0.9))
                }
                Spacer()
                Text("Campus Quiz")
                    .font(Font.system(size: 18, weight: .bold))
                    .foregroundColor(Color.white)
                Spacer()
                Color.clear.frame(width: 24, height: 24) // balance
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 24)

            Text("Pick a Category")
                .font(Font.system(size: 26, weight: .black))
                .foregroundColor(Color.white)
                .padding(.bottom, 6)

            Text("8 questions  •  Earn coins  •  Learn something new")
                .font(Font.system(size: 13))
                .foregroundColor((Color.white as Color).opacity(0.9))
                .padding(.bottom, 32)

            VStack(spacing: 14) {
                ForEach(QuizCategory.allCases) { cat in
                    Button { startQuiz(category: cat) } label: {
                        HStack(spacing: 16) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(cat.color.opacity(0.18))
                                    .frame(width: 56, height: 56)
                                Text(cat.emoji).font(Font.system(size: 28))
                            }
                            VStack(alignment: .leading, spacing: 3) {
                                Text(cat.rawValue)
                                    .font(Font.system(size: 17, weight: .bold))
                                    .foregroundColor(Color.white)
                                Text(cat.hasFunFacts ? "With fun facts after each answer! 🌟" : "8 questions • earn up to $120")
                                    .font(Font.system(size: 12))
                                    .foregroundColor((Color.white as Color).opacity(0.9))
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(Font.system(size: 14, weight: .semibold))
                                .foregroundColor(cat.color)
                        }
                        .padding(14)
                        .background((Color.white as Color).opacity(0.07))
                        .cornerRadius(18)
                        .overlay(RoundedRectangle(cornerRadius: 18)
                            .stroke(cat.color.opacity(0.3), lineWidth: 1.5))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)

            Spacer()
        }
    }

    // MARK: HUD
    private var hudBar: some View {
        HStack(spacing: 12) {
            Button {
                // Back to category picker
                phase = .pickCategory
                selectedCategory = nil
                shuffled = []
                currentIndex = 0
                selectedAnswer = nil
                score = 0; coinsEarned = 0; streak = 0; bestStreak = 0
                saved = false; factScale = 0.85; factOpacity = 0
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(Font.system(size: 24))
                    .foregroundColor((Color.white as Color).opacity(0.9))
            }

            if let cat = selectedCategory {
                HStack(spacing: 5) {
                    Text(cat.emoji).font(Font.system(size: 13))
                    Text(cat.rawValue)
                        .font(Font.system(size: 12, weight: .semibold))
                        .foregroundColor(cat.color)
                }
                .padding(.horizontal, 10).padding(.vertical, 5)
                .background(cat.color.opacity(0.15))
                .cornerRadius(10)
            }

            // Progress dots
            HStack(spacing: 4) {
                ForEach(0..<totalQ, id: \.self) { i in
                    Circle()
                        .fill(i < currentIndex    ? Color.cfGreen
                              : i == currentIndex  ? Color.white
                              : (Color.white as Color).opacity(0.2))
                        .frame(width: i == currentIndex ? 9 : 6,
                               height: i == currentIndex ? 9 : 6)
                        .animation(.spring(response: 0.3), value: currentIndex)
                }
            }

            Spacer()

            if streak >= 2 {
                HStack(spacing: 3) {
                    Text("🔥").font(Font.system(size: 13))
                    Text("\(streak)").font(Font.system(size: 14, weight: .black)).foregroundColor(Color.orange)
                }
            }

            HStack(spacing: 4) {
                Image(systemName: "dollarsign.circle.fill")
                    .foregroundColor(Color.cfGold).font(Font.system(size: 13))
                Text("$\(coinsEarned)")
                    .font(Font.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.cfGold)
            }
            .padding(.horizontal, 9).padding(.vertical, 5)
            .background((Color.cfGold as Color).opacity(0.15))
            .cornerRadius(10)
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 10)
    }

    // MARK: Question Card
    private func questionCard(_ q: HTQuizQuestion) -> some View {
        VStack(spacing: 10) {
            Text("Question \(currentIndex + 1) of \(totalQ)")
                .font(Font.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundColor((Color.white as Color).opacity(0.4))
                .kerning(1.5)
            Text(q.question)
                .font(Font.system(size: 18, weight: .bold))
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(22).frame(maxWidth: .infinity)
        .background((Color.white as Color).opacity(0.07))
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20)
            .stroke((Color.white as Color).opacity(0.1), lineWidth: 1))
    }

    // MARK: Answers
    private func answersStack(_ q: HTQuizQuestion) -> some View {
        VStack(spacing: 10) {
            ForEach(Array(q.answers.enumerated()), id: \.offset) { i, answer in
                HTQuizAnswerButton(
                    text: answer, index: i,
                    selected: selectedAnswer == i,
                    revealed: selectedAnswer != nil,
                    isCorrect: i == q.correctIndex,
                    accentColor: selectedCategory?.color ?? Color.cfMaroon
                ) {
                    guard selectedAnswer == nil else { return }
                    selectedAnswer = i
                    let correct = i == q.correctIndex
                    if correct {
                        score += 1; streak += 1
                        bestStreak = max(bestStreak, streak)
                        coinsEarned += streak >= 3 ? 15 : 10
                    } else { streak = 0 }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.7)) {
                            phase = .showingFunFact(correct: correct)
                            factScale = 1.0; factOpacity = 1.0
                        }
                    }
                }
            }
        }
    }

    // MARK: Fun Fact Card (HT + World only)
    private func funFactCard(_ q: HTQuizQuestion) -> some View {
        let correct: Bool = { if case .showingFunFact(let c) = phase { return c }; return false }()
        return VStack(spacing: 14) {
            resultBanner(q: q, correct: correct)
            Divider().background((Color.white as Color).opacity(0.15))
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 8) {
                    Text(q.funFactEmoji ?? "💡").font(Font.system(size: 22))
                    Text("FUN FACT")
                        .font(Font.system(size: 11, weight: .black, design: .monospaced))
                        .foregroundColor(Color.cfGold).kerning(2)
                }
                Text(q.funFact ?? "")
                    .font(Font.system(size: 14))
                    .foregroundColor((Color.white as Color).opacity(0.88))
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(3)
            }
        }
        .padding(18)
        .background((Color.white as Color).opacity(0.07))
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20)
            .stroke((Color.cfGold as Color).opacity(0.9), lineWidth: 1.5))
    }

    // MARK: Result-only banner (Math / Finance / Career)
    private func resultOnlyBanner(_ q: HTQuizQuestion) -> some View {
        let correct: Bool = { if case .showingFunFact(let c) = phase { return c }; return false }()
        return resultBanner(q: q, correct: correct)
            .padding(18)
            .background((Color.white as Color).opacity(0.07))
            .cornerRadius(20)
    }

    @ViewBuilder
    private func resultBanner(q: HTQuizQuestion, correct: Bool) -> some View {
        HStack(spacing: 10) {
            Text(correct ? "✅" : "❌").font(Font.system(size: 24))
            VStack(alignment: .leading, spacing: 3) {
                Text(correct
                     ? (streak >= 3 ? "Correct! +$15 🔥 Streak!" : "Correct! +$10")
                     : "Not quite!")
                    .font(Font.system(size: 16, weight: .black))
                    .foregroundColor(correct ? Color.cfGreen : Color.red)
                if !correct {
                    Text("Answer: \(q.answers[q.correctIndex])")
                        .font(Font.system(size: 12))
                        .foregroundColor((Color.white as Color).opacity(0.75))
                }
            }
            Spacer()
        }
        .padding(14)
        .background(correct ? (Color.cfGreen as Color).opacity(0.15) : (Color.red as Color).opacity(0.15))
        .cornerRadius(14)
    }

    // MARK: Next button
    private var nextBtn: some View {
        Button {
            let isLast = currentIndex >= totalQ - 1
            withAnimation(.spring(response: 0.35)) {
                if isLast { phase = .finished }
                else {
                    currentIndex += 1; selectedAnswer = nil
                    phase = .answering; factScale = 0.85; factOpacity = 0
                }
            }
        } label: {
            HStack(spacing: 8) {
                Text(currentIndex >= totalQ - 1 ? "See Results" : "Next Question")
                    .font(Font.system(size: 17, weight: .bold))
                Image(systemName: currentIndex >= totalQ - 1 ? "flag.checkered" : "arrow.right")
                    .font(Font.system(size: 15, weight: .bold))
            }
            .foregroundColor(Color.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(LinearGradient(
                colors: [Color.cfMaroon, Color(red: 0.65, green: 0.08, blue: 0.18)],
                startPoint: .leading, endPoint: .trailing))
            .cornerRadius(16)
            .shadow(color: (Color.cfMaroon as Color).opacity(0.9), radius: 10, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: Results
    private var resultsView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 22) {
                Spacer().frame(height: 20)
                Text(score >= 7 ? "🏆 Quiz Master!" : score >= 5 ? "🎯 Solid Work!" : "📚 Keep Learning!")
                    .font(Font.system(size: 30, weight: .black)).foregroundColor(Color.white)

                ZStack {
                    Circle().stroke((Color.white as Color).opacity(0.12), lineWidth: 12).frame(width: 130, height: 130)
                    Circle()
                        .trim(from: 0, to: CGFloat(score) / CGFloat(totalQ))
                        .stroke(score >= 6 ? Color.cfGreen : score >= 4 ? Color.cfGold : Color.cfMaroon,
                                style: StrokeStyle(lineWidth: 12, lineCap: .round))
                        .frame(width: 130, height: 130)
                        .rotationEffect(.degrees(-90))
                        .animation(.spring(response: 1.0), value: score)
                    VStack(spacing: 2) {
                        Text("\(score)/\(totalQ)").font(Font.system(size: 28, weight: .black)).foregroundColor(Color.white)
                        Text("Correct").font(Font.system(size: 12)).foregroundColor((Color.white as Color).opacity(0.9))
                    }
                }

                HStack(spacing: 24) {
                    HTQuizStat(label: "Coins",       value: "+$\(coinsEarned)", color: Color.cfGold)
                    HTQuizStat(label: "Score",        value: "\(score * 10)",    color: Color.cfGreen)
                    HTQuizStat(label: "Best Streak",  value: "\(bestStreak)🔥",  color: Color.orange)
                }

                if !saved {
                    Button {
                        appState.addMoney(coinsEarned)
                        if score > appState.quizHighScore { appState.quizHighScore = score }
                        saved = true
                    } label: {
                        Label("Save Earnings", systemImage: "checkmark.circle.fill")
                            .font(Font.system(size: 17, weight: .bold)).foregroundColor(Color.white)
                            .frame(maxWidth: .infinity).padding(.vertical, 14)
                            .background(Color.cfGreen).cornerRadius(14)
                    }
                    .padding(.horizontal, 20)
                } else {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.circle.fill").foregroundColor(Color.cfGreen)
                        Text("Saved to wallet!").font(Font.system(size: 15, weight: .semibold)).foregroundColor(Color.cfGreen)
                    }
                }

                Button("Try Another Category") {
                    phase = .pickCategory; selectedCategory = nil; shuffled = []
                    currentIndex = 0; selectedAnswer = nil; score = 0; coinsEarned = 0
                    streak = 0; bestStreak = 0; saved = false; factScale = 0.85; factOpacity = 0
                }
                .font(Font.system(size: 15, weight: .semibold))
                .foregroundColor((Color.white as Color).opacity(0.65))

                Button("Exit") { dismiss() }
                    .font(Font.system(size: 14))
                    .foregroundColor((Color.white as Color).opacity(0.4))
            }
            .padding(.horizontal, 20).padding(.bottom, 40)
        }
    }

    // MARK: Setup
    private func startQuiz(category: QuizCategory) {
        selectedCategory = category
        shuffled = Array(htQuizBank.filter { $0.category == category }.shuffled().prefix(totalQ))
        currentIndex = 0; selectedAnswer = nil
        score = 0; coinsEarned = 0; streak = 0; bestStreak = 0
        saved = false; factScale = 0.85; factOpacity = 0
        phase = .answering
    }
}

// MARK: - Answer Button
struct HTQuizAnswerButton: View {
    let text: String; let index: Int
    let selected: Bool; let revealed: Bool; let isCorrect: Bool
    var accentColor: Color = Color.cfMaroon
    let action: () -> Void

    private let letters = ["A","B","C","D"]

    private var bg: Color {
        if !revealed { return selected ? accentColor : (Color.white as Color).opacity(0.07) }
        if isCorrect { return (Color.cfGreen as Color).opacity(0.25) }
        if selected  { return (Color.red as Color).opacity(0.25) }
        return (Color.white as Color).opacity(0.04)
    }
    private var border: Color {
        if !revealed { return selected ? accentColor : (Color.white as Color).opacity(0.12) }
        if isCorrect { return Color.cfGreen }
        if selected  { return Color.red }
        return (Color.white as Color).opacity(0.07)
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    Circle().fill(border.opacity(0.25)).frame(width: 30, height: 30)
                    if revealed && isCorrect {
                        Image(systemName: "checkmark").font(Font.system(size: 13, weight: .black)).foregroundColor(Color.cfGreen)
                    } else if revealed && selected && !isCorrect {
                        Image(systemName: "xmark").font(Font.system(size: 13, weight: .black)).foregroundColor(Color.red)
                    } else {
                        Text(letters[index]).font(Font.system(size: 13, weight: .bold)).foregroundColor(Color.white)
                    }
                }
                Text(text)
                    .font(Font.system(size: 15, weight: selected || (revealed && isCorrect) ? .bold : .medium))
                    .foregroundColor(Color.white)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            .padding(.horizontal, 16).padding(.vertical, 14)
            .background(bg).cornerRadius(14)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(border, lineWidth: 1.5))
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(revealed)
    }
}

// MARK: - Stat Chip
struct HTQuizStat: View {
    let label: String; let value: String; let color: Color
    var body: some View {
        VStack(spacing: 4) {
            Text(value).font(Font.system(size: 20, weight: .black)).foregroundColor(color)
            Text(label).font(Font.system(size: 11)).foregroundColor((Color.white as Color).opacity(0.9))
        }
    }
}
