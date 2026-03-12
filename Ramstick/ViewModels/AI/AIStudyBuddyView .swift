
// AI powered by OpenRouter — with full Accessibility support

import SwiftUI
import Combine
private let openRouterKey = ProcessInfo.processInfo.environment["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"] ?? ""
private let openRouterModel = "google/gemma-3n-e4b-it:free"

// MARK: - Message Model
struct ChatMessage: Identifiable {
    let id        = UUID()
    let role:      MessageRole
    let text:      String
    let timestamp: Date = Date()
}
enum MessageRole { case user, assistant }

// MARK: - Chat Mode
enum AIMode: String, CaseIterable, Identifiable {
    case advisor  = "Academic Advisor"
    case essay    = "Essay Helper"
    case contacts = "HT Contacts"
    case general  = "General Help"

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .advisor:  return "🎓"
        case .essay:    return "✍️"
        case .contacts: return "📬"
        case .general:  return "💬"
        }
    }

    var color: Color {
        switch self {
        case .advisor:  return Color.cfMaroon
        case .essay:    return Color.cfGreen
        case .contacts: return Color.cfGold
        case .general:  return Color.blue
        }
    }

    var systemPrompt: String {
        let base = """
        You are an AI assistant in the CampusFlow app for students at \
        Huston-Tillotson University (HT), an HBCU in Austin, Texas. \
        Students are ages 18-24. Be warm, encouraging, and speak like a \
        knowledgeable older peer — not stiff or corporate. \
        Keep responses concise and actionable.
        """
        switch self {
        case .advisor:
            return base + """
             You are simulating an HT Academic Advisor. Help with course selection, \
            degree planning, GPA improvement, academic probation recovery, double majors, \
            and study strategies. When relevant mention: registrar@htu.edu or (512) 505-3027.
            """
        case .essay:
            return base + """
             You are an expert essay coach. Help students write and improve essays for \
            scholarships, internships, cover letters, and grad school. Give specific \
            feedback and help them tell their authentic story as an HBCU student.
            """
        case .contacts:
            return base + """
             Help students find the right HT contact. \
            Financial Aid: finaid@htu.edu (512)505-3031 | \
            Registrar: registrar@htu.edu (512)505-3027 | \
            Admissions: admissions@htu.edu (512)505-3029 | \
            Student Affairs: studentaffairs@htu.edu (512)505-3050 | \
            Career Services: careerservices@htu.edu (512)505-3038 | \
            Tutoring: tutoring@htu.edu (512)505-3072 | \
            Counseling: counseling@htu.edu (512)505-3045 | \
            Housing: housing@htu.edu (512)505-3055 | \
            Bursar: bursar@htu.edu (512)505-3033 | \
            IT Help: helpdesk@htu.edu (512)505-3060. \
            Always provide contact info AND write a ready-to-send email template.
            """
        case .general:
            return base + """
             You are a student success coach. Answer questions about campus life, \
            time management, mental health, financial literacy, networking, and \
            anything a college student needs. Always be encouraging.
            """
        }
    }

    var greeting: String {
        switch self {
        case .advisor:
            return "Hey! I'm your HT Academic Advisor AI 🎓\n\nI can help with course selection, degree planning, GPA strategies, and more. What's going on academically?"
        case .essay:
            return "Let's write something powerful ✍️\n\nShare a prompt or paste a draft and I'll give you real feedback. Scholarship essay, cover letter, personal statement — I've got you."
        case .contacts:
            return "Need to reach someone at HT? 📬\n\nTell me what you need and I'll find the right office, give you their contact info, AND write an email you can send right now."
        case .general:
            return "What's on your mind? 💬\n\nI'm here for anything — campus life, stress, money, time management, career advice. No question is too small!"
        }
    }

    var quickPrompts: [String] {
        switch self {
        case .advisor:  return ["How do I dispute a grade?", "What classes should I take freshman year?", "How do I recover from academic probation?", "Best study schedule tips?"]
        case .essay:    return ["Help me write my personal essay", "Help me start a scholarship essay", "Review my personal statement", "How do I discuss overcoming challenges?"]
        case .contacts: return ["Who handles financial aid appeals?", "Email to dispute a grade", "How do I reach career services?", "Who do I contact about housing?"]
        case .general:  return ["How do I manage stress during finals?", "Tips for networking as a student", "How do I build credit in college?", "Balancing work and school?"]
        }
    }
}

// MARK: - ViewModel
class AIStudyBuddyViewModel: ObservableObject {
    @Published var messages:     [ChatMessage] = []
    @Published var inputText:    String        = ""
    @Published var isLoading:    Bool          = false
    @Published var currentMode:  AIMode        = .general
    @Published var errorMessage: String?       = nil

    var conversationHistory: [[String: Any]] = []

    func switchMode(_ mode: AIMode) {
        currentMode         = mode
        messages            = []
        conversationHistory = []
        errorMessage        = nil
        addGreeting()
    }

    func addGreeting() {
        messages.append(ChatMessage(role: .assistant, text: currentMode.greeting))
    }


    // MARK: - Instant pre-written answers (no API needed)
    private static let instantAnswers: [(keywords: [String], answer: String)] = [

        // SCHOLARSHIPS
        (["scholarship", "scholarships", "apply for", "free money", "aid", "awards"],
         """
         Here are the top scholarships every HT student should apply for 🏆

         On-Campus:
         • HT Excellence Scholarship — $2,500/yr (3.0+ GPA required)
         • HT Need-Based Grant — contact finaid@htu.edu to apply
         • HT Leadership Award — apply through Student Affairs

         External HBCU Scholarships:
         • UNCF Scholarships — uncf.org (hundreds of awards!)
         • Google HBCU Scholars — $10,000, for STEM majors
         • Thurgood Marshall Scholarship — tmcf.org
         • Texas Higher Education TEXAS Grant — auto-applied via FAFSA

         Tips:
         ✅ Complete FAFSA every October at studentaid.gov
         ✅ Apply to 10+ scholarships — most take under 30 min
         ✅ Visit finaid@htu.edu or call (512) 505-3031 for HT-specific awards

         Want help writing a scholarship essay? Switch to Essay Helper mode!
         """),

        // FINANCIAL AID
        (["fafsa", "financial aid", "pell", "pell grant", "loan", "fasfa"],
         """
         FAFSA & Financial Aid Guide 💰

         File at studentaid.gov — HT school code: 003576
         Deadline: October 1st each year (earlier = more aid!)

         Types of Aid:
         • Pell Grant — free money, no repayment (up to $7,395/yr)
         • Subsidized Loans — interest-free while enrolled
         • Work-Study — earn money on campus

         Contact HT Financial Aid:
         📧 finaid@htu.edu
         📞 (512) 505-3031
         🏢 Academic Affairs Building, Room 114

         Need help with a financial aid appeal? Just ask and I'll write the letter!
         """),

        // ADVISOR / REGISTRATION
        (["advisor", "adviser", "register", "registration", "classes", "courses", "schedule"],
         """
         Academic Advising at HT 🎓

         Find your advisor:
         1. Log into MyHT portal → Student Services → Academic Advising
         2. Or call the Registrar: (512) 505-3027
         3. Email: registrar@htu.edu

         Registration tips:
         • Check your registration date/time in MyHT
         • Have backup classes ready — popular ones fill fast
         • Clear any holds BEFORE your registration window opens

         Common holds that block registration:
         ⚠️ Financial hold → bursar@htu.edu / (512) 505-3033
         ⚠️ Academic hold → Registrar (512) 505-3027
         ⚠️ Health hold → Student Health (512) 505-3052

         Want me to write an email to your advisor? Just say what you need!
         """),

        // INTERNSHIPS / CAREER
        (["internship", "internships", "job", "career", "resume", "work experience"],
         """
         Landing Internships as an HT Student 💼

         Start here:
         📧 careerservices@htu.edu / (512) 505-3038
         They do FREE resume reviews, mock interviews, and job postings
         Also check Handshake — log in with your HT email

         Top programs for HBCU students:
         🔹 Google HBCU Internship Program — careers.google.com
         🔹 Microsoft HBCU Scholarship & Internship
         🔹 City of Austin Internships — austintexas.gov/jobs
         🔹 UNCF Career Pathways Initiative — uncf.org
         🔹 Congressional Black Caucus Foundation Internship

         Resume tips:
         ✅ Keep it to 1 page
         ✅ Quantify results — "increased X by 20%"
         ✅ Include GPA if 3.0+
         ✅ Tailor it for each application

         Want me to review your resume or write a cover letter? Paste it here!
         """),

        // GPA / GRADES
        (["gpa", "grade", "grades", "failing", "probation", "academic probation", "improve my gpa"],
         """
         GPA Recovery & Grade Help 📈

         If you're struggling right now:
         1. Email your professor TODAY — ask about extra credit or office hours
         2. Visit the HT Tutoring Center: tutoring@htu.edu / (512) 505-3072
         3. Ask your advisor about grade forgiveness or course repeat options

         Academic probation recovery:
         • You need 2.0+ GPA to stay in good standing
         • Meet with your advisor immediately — they'll create a recovery plan
         • Consider reducing your course load if overwhelmed
         • Use the tutoring center — it's FREE

         GPA improvement strategies:
         ✅ Attend every class — attendance impacts grades more than anything
         ✅ Do homework same day it's assigned
         ✅ Form study groups with classmates
         ✅ Go to professor office hours — they remember who shows effort

         Want me to write an email to a professor about your grade?
         """),

        // STRESS / MENTAL HEALTH
        (["stress", "stressed", "anxiety", "overwhelmed", "mental health", "depressed", "counseling"],
         """
         You're not alone — HT has your back 💙

         Free Counseling at HT:
         📧 counseling@htu.edu
         📞 (512) 505-3045
         FREE and confidential for all enrolled students

         Quick stress relief:
         • 5-minute rule: just start the task for 5 min — momentum builds
         • Box breathing: inhale 4 counts, hold 4, exhale 4, hold 4
         • Pomodoro: 25 min focus, 5 min break — repeat
         • Talk to someone — your RA, advisor, or a friend

         If it feels urgent:
         🆘 Crisis Text Line: text HOME to 741741
         🆘 Suicide & Crisis Lifeline: call or text 988

         Asking for help is the strongest thing you can do. What's going on?
         """),

        // HOUSING
        (["housing", "dorm", "dorms", "roommate", "live on campus", "residence hall"],
         """
         HT Housing Info 🏠

         Contact Housing:
         📧 housing@htu.edu
         📞 (512) 505-3055

         Residence Halls:
         • Frederick Douglass Hall (co-ed)
         • Dogan Hall (women)
         • Allen Hall (men)

         How to apply:
         1. Log into MyHT portal → Housing Application
         2. Pay the housing deposit to secure your spot
         3. Submit roommate requests in the portal

         Tips:
         ✅ Apply early — spots fill fast
         ✅ Bring twin XL bedding, shower caddy, and a power strip
         ✅ Review your roommate agreement with your RA on move-in day

         Need help writing an email about a housing issue? Just ask!
         """),

        // TUTORING
        (["tutor", "tutoring", "study help", "math help", "writing help", "struggling in class"],
         """
         Free Tutoring at HT 📚

         HT Tutoring Center:
         📧 tutoring@htu.edu
         📞 (512) 505-3072
         Drop-in and scheduled sessions — completely FREE

         Subjects covered:
         Math, English, Writing, Sciences, Business, most 100 & 200 level courses

         Writing Center:
         Get help with essays, papers, and scholarship applications
         Contact tutoring@htu.edu to schedule a session

         Free online resources:
         • Khan Academy — khanacademy.org
         • Wolfram Alpha — for math problems
         • Purdue OWL — for writing and citations

         What subject are you struggling with? I can give you specific strategies!
         """),
    ]

    // Returns instant answer if question matches a keyword — no API call needed
    private func instantAnswer(for text: String) -> String? {
        let lower = text.lowercased()
        for entry in Self.instantAnswers {
            if entry.keywords.contains(where: { lower.contains($0) }) {
                return entry.answer
            }
        }
        return nil
    }

    func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty, !isLoading else { return }

        inputText    = ""
        errorMessage = nil
        messages.append(ChatMessage(role: .user, text: text))

        // ── Check instant answers first (no network needed) ──
        if let instant = instantAnswer(for: text) {
            messages.append(ChatMessage(role: .assistant, text: instant))
            conversationHistory.append(["role": "user",      "content": text])
            conversationHistory.append(["role": "assistant", "content": instant])
            return
        }

        // ── Fall back to AI for anything not pre-answered ──
        isLoading    = true

        var allMessages = conversationHistory
        allMessages.append(["role": "user", "content": text])

        // Prepend system prompt into first message for model compatibility
        if allMessages.count == 1 {
            let combined = currentMode.systemPrompt + "\n\n" + text
            allMessages[0] = ["role": "user", "content": combined]
        }

        Task {
            do {
                let reply = try await callOpenRouter(messages: allMessages)
                await MainActor.run {
                    messages.append(ChatMessage(role: .assistant, text: reply))
                    conversationHistory.append(["role": "user",      "content": text])
                    conversationHistory.append(["role": "assistant", "content": reply])
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Connection issue. Check your internet and try again."
                    isLoading    = false
                }
            }
        }
    }

    private func callOpenRouter(messages: [[String: Any]]) async throws -> String {
        let url = URL(string: "https://openrouter.ai/api/v1/chat/completions")!
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json",        forHTTPHeaderField: "Content-Type")
        req.setValue("Bearer \(openRouterKey)", forHTTPHeaderField: "Authorization")
        req.timeoutInterval = 30
        
        
        var allMessages = conversationHistory
        if let first = allMessages.first {
            let combined = currentMode.systemPrompt + "\n\n" + ((first["content"] as? String) ?? "")
            allMessages[0] = ["role": "user", "content": combined]
        } else {
            allMessages = [["role": "user", "content": currentMode.systemPrompt]]
        }

        let body: [String: Any] = [
            "model": "google/gemma-3n-e4b-it:free",
            "messages": allMessages,
            "max_tokens": 800
        ]
        req.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, _) = try await URLSession.shared.data(for: req)
        let json      = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        let choices   = json?["choices"] as? [[String: Any]]
        let message   = choices?.first?["message"] as? [String: Any]
        return (message?["content"] as? String) ?? "Sorry, I couldn't process that. Try again!"
    }
}

// MARK: - Main View
struct AIStudyBuddyView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var a11y: AccessibilityManager
    @StateObject private var vm = AIStudyBuddyViewModel()
    @FocusState private var inputFocused: Bool

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                modeSelectorStrip

                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 12) {
                            ForEach(vm.messages) { msg in
                                A11yChatBubble(
                                    message:   msg,
                                    modeColor: vm.currentMode.color,
                                    a11y:      a11y
                                )
                                .id(msg.id)
                            }
                            if vm.isLoading {
                                TypingIndicator(color: vm.currentMode.color)
                            }
                            if let err = vm.errorMessage {
                                ErrorBanner(message: err) { vm.errorMessage = nil }
                            }
                            Color.clear.frame(height: 8).id("bottom")
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        .padding(.bottom, 8)
                    }
                    .onChange(of: vm.messages.count) { _ in
                        withAnimation { proxy.scrollTo("bottom") }
                    }
                    .onChange(of: vm.isLoading) { _ in
                        withAnimation { proxy.scrollTo("bottom") }
                    }
                }

                if vm.messages.count <= 1 {
                    quickPromptsRow
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                Divider()
                inputBar
            }
            .background((a11y.highContrast ? Color.black : Color.cfBackground).ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        Text(vm.currentMode.emoji)
                            .font(Font.system(size: 18))
                        VStack(spacing: 0) {
                            Text("AI Study Buddy")
                                .font(Font.system(size: a11y.fontSize(16), weight: .bold))
                                .foregroundColor(a11y.primaryText)
                            Text(vm.currentMode.rawValue)
                                .font(Font.system(size: a11y.fontSize(11)))
                                .foregroundColor(vm.currentMode.color)
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        vm.messages            = []
                        vm.conversationHistory = []
                        vm.addGreeting()
                    } label: {
                        Image(systemName: "arrow.counterclockwise.circle")
                            .foregroundColor(Color.secondary)
                    }
                    .accessibilityLabel("Restart conversation")
                }
            }
        }
        .onAppear { vm.addGreeting() }
    }

    // MARK: Mode strip
    private var modeSelectorStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(AIMode.allCases) { mode in
                    Button {
                        withAnimation(.spring(response: 0.35)) { vm.switchMode(mode) }
                    } label: {
                        HStack(spacing: 5) {
                            Text(mode.emoji)
                                .font(Font.system(size: 13))
                            Text(mode.rawValue)
                                .font(Font.system(size: a11y.fontSize(12), weight: .semibold))
                                .foregroundColor(vm.currentMode == mode ? Color.white : mode.color)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(vm.currentMode == mode ? mode.color : mode.color.opacity(0.1))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(
                                    a11y.highContrast ? Color.white.opacity(0.4) : Color.clear,
                                    lineWidth: 1
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .accessibilityLabel("\(mode.rawValue) mode")
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .background(a11y.highContrast ? Color(white: 0.1) : Color.cfCard)
    }

    // MARK: Quick prompts
    private var quickPromptsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(vm.currentMode.quickPrompts, id: \.self) { prompt in
                    Button {
                        vm.inputText = prompt
                        vm.sendMessage()
                    } label: {
                        Text(prompt)
                            .font(Font.system(size: a11y.fontSize(12), weight: .medium))
                            .foregroundColor(a11y.highContrast ? Color.white : vm.currentMode.color)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                a11y.highContrast
                                    ? Color.white.opacity(0.1)
                                    : vm.currentMode.color.opacity(0.08)
                            )
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        a11y.highContrast
                                            ? Color.white.opacity(0.3)
                                            : vm.currentMode.color.opacity(0.25),
                                        lineWidth: 1
                                    )
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .background(a11y.highContrast ? Color(white: 0.08) : Color.cfCard.opacity(0.5))
    }

    // MARK: Input bar
    private var inputBar: some View {
        HStack(spacing: 10) {
            ZStack(alignment: .leading) {
                if vm.inputText.isEmpty {
                    Text("Ask anything…")
                        .font(Font.system(size: a11y.fontSize(15)))
                        .foregroundColor(Color.secondary)
                        .padding(.horizontal, 14)
                }
                TextField("", text: $vm.inputText, axis: .vertical)
                    .font(Font.system(size: a11y.fontSize(15)))
                    .foregroundColor(a11y.primaryText)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .focused($inputFocused)
                    .lineLimit(1...4)
                    .onSubmit { vm.sendMessage() }
            }
            .background(a11y.cardBG)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(vm.currentMode.color.opacity(a11y.highContrast ? 0.8 : 0.3), lineWidth: a11y.highContrast ? 2 : 1.5)
            )

            Button {
                vm.sendMessage()
                inputFocused = false
            } label: {
                ZStack {
                    Circle()
                        .fill(vm.inputText.trimmingCharacters(in: .whitespaces).isEmpty
                              ? (Color.gray as Color).opacity(0.2)
                              : vm.currentMode.color)
                        .frame(width: 44, height: 44)
                    Image(systemName: "arrow.up")
                        .font(Font.system(size: a11y.fontSize(16), weight: .bold))
                        .foregroundColor(
                            vm.inputText.trimmingCharacters(in: .whitespaces).isEmpty
                                ? Color.secondary : Color.white
                        )
                }
            }
            .disabled(vm.inputText.trimmingCharacters(in: .whitespaces).isEmpty || vm.isLoading)
            .accessibilityLabel("Send message")
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(a11y.highContrast ? Color.black : Color.cfBackground)
    }
}

// MARK: - Accessibility-aware Chat Bubble
struct A11yChatBubble: View {
    let message:   ChatMessage
    let modeColor: Color
    let a11y:      AccessibilityManager

    var isUser: Bool { message.role == .user }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isUser { Spacer(minLength: 44) }

            if !isUser {
                ZStack {
                    Circle()
                        .fill(modeColor.opacity(a11y.highContrast ? 0.35 : 0.15))
                        .frame(width: 32, height: 32)
                    Text("🤖").font(Font.system(size: 16))
                }
            }

            VStack(alignment: isUser ? .trailing : .leading, spacing: 4) {
                HStack(alignment: .top, spacing: 6) {
                    if !isUser {
                        // Speak button for AI responses
                        SpeakButton(text: message.text)
                            .environmentObject(a11y)
                    }

                    Text(message.text)
                        .font(Font.system(size: a11y.fontSize(15)))
                        .foregroundColor(
                            isUser
                                ? Color.white
                                : (a11y.highContrast ? Color.white : Color.cfDark)
                        )
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(
                            isUser
                                ? (a11y.highContrast ? Color.white.opacity(0.25) : modeColor)
                                : (a11y.highContrast ? Color(white: 0.15) : Color.cfCard)
                        )
                        .cornerRadius(18)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(
                                    a11y.highContrast ? Color.white.opacity(0.3) : Color.clear,
                                    lineWidth: 1
                                )
                        )
                }

                Text(timeString(message.timestamp))
                    .font(Font.system(size: a11y.fontSize(10)))
                    .foregroundColor(Color.secondary)
            }

            if !isUser { Spacer(minLength: 44) }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(isUser ? "You" : "AI"): \(message.text)")
    }

    private func timeString(_ date: Date) -> String {
        let f = DateFormatter()
        f.timeStyle = .short
        return f.string(from: date)
    }
}

// MARK: - Typing Indicator
struct TypingIndicator: View {
    let color: Color
    @State private var dot1 = false
    @State private var dot2 = false
    @State private var dot3 = false

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ZStack {
                Circle().fill(color.opacity(0.15)).frame(width: 32, height: 32)
                Text("🤖").font(Font.system(size: 16))
            }
            HStack(spacing: 5) {
                Circle().fill(color.opacity(0.6)).frame(width: 7, height: 7).offset(y: dot1 ? -4 : 0)
                Circle().fill(color.opacity(0.6)).frame(width: 7, height: 7).offset(y: dot2 ? -4 : 0)
                Circle().fill(color.opacity(0.6)).frame(width: 7, height: 7).offset(y: dot3 ? -4 : 0)
            }
            .padding(.horizontal, 16).padding(.vertical, 12)
            .background(Color.cfCard)
            .cornerRadius(18)
            Spacer()
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.4).repeatForever().delay(0.00)) { dot1.toggle() }
            withAnimation(.easeInOut(duration: 0.4).repeatForever().delay(0.15)) { dot2.toggle() }
            withAnimation(.easeInOut(duration: 0.4).repeatForever().delay(0.30)) { dot3.toggle() }
        }
        .accessibilityLabel("AI is typing")
    }
}

// MARK: - Error Banner
struct ErrorBanner: View {
    let message:   String
    let onDismiss: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill").foregroundColor(Color.orange)
            Text(message).font(Font.system(size: 13)).foregroundColor(Color.cfDark)
            Spacer()
            Button(action: onDismiss) {
                Image(systemName: "xmark").font(Font.system(size: 12)).foregroundColor(Color.secondary)
            }
        }
        .padding(12)
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Corner Radius Helper
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius:  CGFloat
    var corners: UIRectCorner
    func path(in rect: CGRect) -> Path {
        let p = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(p.cgPath)
    }
}
