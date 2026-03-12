

import SwiftUI

// MARK: - Models (moved here from OpportunityData.swift)

enum OppCategory: String, CaseIterable {
    case scholarship = "Scholarship"
    case internship  = "Internship"
    case grant       = "Grant"
    case mentorship  = "Mentorship"
    case event       = "Event"

    var emoji: String {
        switch self {
        case .scholarship: return "🏅"
        case .internship:  return "💼"
        case .grant:       return "📋"
        case .mentorship:  return "🤝"
        case .event:       return "🎟️"
        }
    }
    var color: Color {
        switch self {
        case .scholarship: return Color.cfGold
        case .internship:  return Color.cfGreen
        case .grant:       return Color.cfMaroon
        case .mentorship:  return Color.blue
        case .event:       return Color.purple
        }
    }
}

struct HTOpportunity: Identifiable {
    let id: String
    let title: String
    let organization: String
    let category: OppCategory
    let amount: String
    let description: String
    let cost: Int
    let deadline: String
    let contactName: String
    let contactEmail: String
    let contactPhone: String
    let applicationSteps: [String]
    let emailTemplate: String
}

// MARK: - Data

let allOpportunities: [HTOpportunity] = [
    HTOpportunity(
        id: "opp_1",
        title: "HT Excellence Scholarship",
        organization: "Huston-Tillotson University",
        category: .scholarship,
        amount: "$2,500/year",
        description: "Merit-based scholarship for returning HT students with a GPA of 3.0 or higher. Renewable annually.",
        cost: 30,
        deadline: "March 1st",
        contactName: "Financial Aid Office",
        contactEmail: "finaid@htu.edu",
        contactPhone: "(512) 505-3031",
        applicationSteps: [
            "Maintain a 3.0+ GPA",
            "Complete the FAFSA by February 1st",
            "Submit a 500-word personal statement",
            "Provide 2 letters of recommendation",
            "Submit official transcripts",
            "Apply through the HT portal by March 1st"
        ],
        emailTemplate: """
Subject: HT Excellence Scholarship Application Inquiry

Dear Financial Aid Team,

My name is [YOUR NAME], and I am a [YEAR] student at Huston-Tillotson University majoring in [MAJOR]. I am writing to inquire about the HT Excellence Scholarship and confirm the application requirements.

I currently maintain a [GPA] GPA and am committed to academic excellence at HT.

Could you please confirm the application deadline and any additional requirements?

Thank you for your time.

Sincerely,
[YOUR NAME]
[STUDENT ID]
[PHONE NUMBER]
"""
    ),
    HTOpportunity(
        id: "opp_2",
        title: "Google HBCU Scholars Program",
        organization: "Google",
        category: .scholarship,
        amount: "$10,000",
        description: "Google's scholarship for HBCU students pursuing degrees in Computer Science, Engineering, or related fields.",
        cost: 50,
        deadline: "December 1st",
        contactName: "HT Career Services",
        contactEmail: "careerservices@htu.edu",
        contactPhone: "(512) 505-3038",
        applicationSteps: [
            "Declare a major in CS, Engineering, or related STEM field",
            "Maintain a 3.2+ GPA",
            "Complete Google's online application at buildyourfuture.withgoogle.com",
            "Write two essays (500 words each)",
            "Submit a current resume",
            "Provide 1 letter of recommendation from a professor",
            "Attend virtual interview if selected"
        ],
        emailTemplate: """
Subject: Google HBCU Scholar Program — Application Support Request

Dear Career Services Team,

I am a [YEAR] student majoring in [MAJOR] at HT, and I am preparing my application for the Google HBCU Scholars Program.

I would greatly appreciate guidance on strengthening my application, particularly reviewing my resume and essays. Could we schedule a meeting?

Thank you,
[YOUR NAME]
[STUDENT ID] | [EMAIL]
"""
    ),
    HTOpportunity(
        id: "opp_3",
        title: "City of Austin Internship",
        organization: "City of Austin",
        category: .internship,
        amount: "$18/hr",
        description: "Paid summer internship with the City of Austin across departments including Technology, Planning, Finance, and Communications.",
        cost: 40,
        deadline: "February 15th",
        contactName: "HT Career Services",
        contactEmail: "careerservices@htu.edu",
        contactPhone: "(512) 505-3038",
        applicationSteps: [
            "Browse open roles at austintexas.gov/jobs",
            "Create an account on the City of Austin jobs portal",
            "Prepare a 1-page resume tailored to the department",
            "Write a cover letter specific to the role",
            "Submit your application online",
            "Complete a background check if offered an interview",
            "Register your internship with HT Career Services for credit"
        ],
        emailTemplate: """
Subject: Internship Application — [DEPARTMENT NAME]

Dear Hiring Manager,

I am [YOUR NAME], a [YEAR] student at Huston-Tillotson University majoring in [MAJOR]. I am applying for the [ROLE] internship within the [DEPARTMENT] at the City of Austin.

As an HT student, I am deeply committed to serving the Austin community.

Thank you for considering my application.

Sincerely,
[YOUR NAME]
[PHONE] | [EMAIL]
"""
    ),
    HTOpportunity(
        id: "opp_4",
        title: "UNCF Student Opportunity Scholarship",
        organization: "United Negro College Fund",
        category: .scholarship,
        amount: "$2,000–$8,000",
        description: "UNCF offers multiple scholarship opportunities specifically for HBCU students. Awards vary based on financial need and academic achievement.",
        cost: 35,
        deadline: "Rolling — check UNCF portal",
        contactName: "Financial Aid Office",
        contactEmail: "finaid@htu.edu",
        contactPhone: "(512) 505-3031",
        applicationSteps: [
            "Create a free profile at scholarships.uncf.org",
            "Complete the UNCF scholarship application",
            "Submit FAFSA and Student Aid Report (SAR)",
            "Write a personal statement (requirements vary by award)",
            "Upload official transcripts",
            "Submit financial documentation if required",
            "Monitor your email for selection notifications"
        ],
        emailTemplate: """
Subject: UNCF Scholarship Application — Transcript Request

Dear Registrar,

I am applying for a UNCF scholarship and need an official transcript sent electronically.

Name: [YOUR FULL NAME]
Student ID: [ID]
Date of Birth: [DOB]

Please send the transcript to: scholarships@uncf.org

Thank you,
[YOUR NAME] | [PHONE]
"""
    ),
    HTOpportunity(
        id: "opp_5",
        title: "HT Peer Mentorship Program",
        organization: "HT Student Affairs",
        category: .mentorship,
        amount: "Free + Resume Experience",
        description: "Connect with upperclassmen mentors or become a mentor yourself. Earn leadership credit and strengthen your academic network.",
        cost: 30,
        deadline: "Open enrollment — September & January",
        contactName: "Student Affairs Office",
        contactEmail: "studentaffairs@htu.edu",
        contactPhone: "(512) 505-3050",
        applicationSteps: [
            "Email Student Affairs to express interest",
            "Complete the Mentorship Program interest form",
            "Attend a 1-hour orientation session",
            "Be matched with a mentor or mentee",
            "Commit to bi-weekly check-ins for one semester",
            "Complete mid-semester and end-of-semester reflections"
        ],
        emailTemplate: """
Subject: Interest in HT Peer Mentorship Program

Dear Student Affairs Team,

My name is [YOUR NAME], a [YEAR] student at HT majoring in [MAJOR]. I am writing to express my interest in joining the Peer Mentorship Program as a [MENTOR/MENTEE].

Please let me know the next steps to enroll.

Thank you,
[YOUR NAME]
[STUDENT ID] | [EMAIL]
"""
    ),
    HTOpportunity(
        id: "opp_6",
        title: "Texas Higher Education Grant (THECB)",
        organization: "Texas Higher Education Coordinating Board",
        category: .grant,
        amount: "Up to $6,200/year",
        description: "The TEXAS Grant is need-based financial aid for Texas residents attending in-state colleges. Renewable for up to 6 years.",
        cost: 40,
        deadline: "As early as possible after Oct 1st",
        contactName: "Financial Aid Office",
        contactEmail: "finaid@htu.edu",
        contactPhone: "(512) 505-3031",
        applicationSteps: [
            "Be a Texas resident for at least 12 months",
            "Demonstrate financial need via FAFSA",
            "Complete the FAFSA at studentaid.gov after October 1st",
            "Enroll at least half-time at HT",
            "Maintain satisfactory academic progress",
            "Renew FAFSA each academic year by the priority deadline"
        ],
        emailTemplate: """
Subject: TEXAS Grant Eligibility Inquiry

Dear Financial Aid Advisor,

I am a Texas resident and current HT student writing to confirm my eligibility for the TEXAS Grant program.

Could you review my financial aid file and let me know if there are any additional steps I need to complete?

Name: [YOUR NAME]
Student ID: [ID]
Year: [ACADEMIC YEAR]

Thank you,
[YOUR NAME] | [PHONE]
"""
    ),
    HTOpportunity(
        id: "opp_7",
        title: "Microsoft LEAP Apprenticeship",
        organization: "Microsoft",
        category: .internship,
        amount: "$25/hr + Benefits",
        description: "Microsoft's engineering apprenticeship for non-traditional tech talent including HBCU students. Full-time 16-week paid program.",
        cost: 60,
        deadline: "January 31st",
        contactName: "HT Career Services",
        contactEmail: "careerservices@htu.edu",
        contactPhone: "(512) 505-3038",
        applicationSteps: [
            "Apply at microsoft.com/en-us/leap",
            "Prepare a technical resume highlighting coding experience",
            "Complete an online coding assessment (practice on LeetCode)",
            "Submit a brief personal essay on your non-traditional background",
            "Technical phone screen if shortlisted",
            "Final panel interview (virtual)",
            "Register the apprenticeship with HT Career Services"
        ],
        emailTemplate: """
Subject: Microsoft LEAP Apprenticeship — Reference Request

Dear Professor [NAME],

I am applying for the Microsoft LEAP Apprenticeship Program, which supports non-traditional engineering talent.

I am reaching out to ask if you would be willing to serve as a reference. Your course, [COURSE NAME], significantly shaped my interest in [FIELD].

Would you be comfortable with me listing your email as a reference contact?

Thank you,
[YOUR NAME]
[STUDENT ID] | [EMAIL]
"""
    ),
    HTOpportunity(
        id: "opp_8",
        title: "HT Leadership Summit",
        organization: "HT Student Government",
        category: .event,
        amount: "Free + Networking",
        description: "Annual leadership development summit featuring keynote speakers, workshops on resume building, networking, and professional development.",
        cost: 30,
        deadline: "Registration opens each spring",
        contactName: "Student Affairs Office",
        contactEmail: "studentaffairs@htu.edu",
        contactPhone: "(512) 505-3050",
        applicationSteps: [
            "Watch your HT email for registration announcements",
            "Register through the Student Affairs portal",
            "Prepare a 30-second elevator pitch about yourself",
            "Bring printed copies of your resume",
            "Dress business casual or professional",
            "Follow up with new connections on LinkedIn within 24 hours"
        ],
        emailTemplate: """
Subject: HT Leadership Summit — Registration Inquiry

Dear Student Affairs Team,

I am very interested in attending the upcoming HT Leadership Summit and would like to confirm registration details and any preparation materials.

Thank you,
[YOUR NAME]
[YEAR] | [MAJOR]
[EMAIL] | [PHONE]
"""
    ),
]

// MARK: - Main View

struct OpportunitiesView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedCategory: OppCategory? = nil
    @State private var selectedOpp: HTOpportunity?    = nil
    @State private var showUnlockAlert                = false
    @State private var pendingOpp: HTOpportunity?     = nil
    @State private var showUnlockBurst                = false
    @State private var burstOppTitle                  = ""

    private var filtered: [HTOpportunity] {
        guard let cat = selectedCategory else { return allOpportunities }
        return allOpportunities.filter { $0.category == cat }
    }

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 18) {
                    balanceBanner
                    categoryFilter
                    opportunityList
                }
                .padding(.top, 12)
                .padding(.bottom, 32)
            }
            .background(Color.cfBackground.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Opportunities")
                        .font(Font.system(size: 18, weight: .bold))
                        .foregroundColor(Color.cfDark)
                }
            }
        }
        .sheet(item: $selectedOpp) { opp in
            OppDetailSheet(opp: opp, isUnlocked: appState.unlockedOpportunityIDs.contains(opp.id))
                .environmentObject(appState)
        }
        .alert("Unlock Opportunity?", isPresented: $showUnlockAlert, presenting: pendingOpp) { opp in
            Button("Spend $\(opp.cost) to Unlock") {
                if appState.unlockOpportunity(id: opp.id, cost: opp.cost) {
                    burstOppTitle = opp.title
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        showUnlockBurst = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                        withAnimation(.easeOut(duration: 0.4)) { showUnlockBurst = false }
                        selectedOpp = opp
                    }
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: { opp in
            Text("Unlock \"\(opp.title)\" for $\(opp.cost) coins? You'll get the checklist, contact info, and a ready-to-send email template.")
        }
        // ── Unlock burst animation overlay
        .overlay {
            if showUnlockBurst {
                ZStack {
                    // Blurred dark backdrop
                    Color.black.opacity(0.65).ignoresSafeArea()

                    VStack(spacing: 22) {

                        // Pulsing rings + lock icon
                        ZStack {
                            Circle()
                                .stroke(Color.cfGold.opacity(0.15), lineWidth: 2)
                                .frame(width: 220, height: 220)
                                .scaleEffect(showUnlockBurst ? 1.0 : 0.3)
                                .animation(.spring(response: 0.6, dampingFraction: 0.5).delay(0.05), value: showUnlockBurst)

                            Circle()
                                .stroke(Color.cfGold.opacity(0.25), lineWidth: 2)
                                .frame(width: 165, height: 165)
                                .scaleEffect(showUnlockBurst ? 1.0 : 0.3)
                                .animation(.spring(response: 0.55, dampingFraction: 0.45).delay(0.0), value: showUnlockBurst)

                            Circle()
                                .fill(Color.cfGold.opacity(0.18))
                                .frame(width: 115, height: 115)
                                .scaleEffect(showUnlockBurst ? 1.0 : 0.1)
                                .animation(.spring(response: 0.5, dampingFraction: 0.4), value: showUnlockBurst)

                            Image(systemName: "lock.open.fill")
                                .font(.system(size: 52, weight: .black))
                                .foregroundColor(Color.cfGold)
                                .scaleEffect(showUnlockBurst ? 1.15 : 0.1)
                                .rotationEffect(.degrees(showUnlockBurst ? 0 : -45))
                                .animation(.spring(response: 0.45, dampingFraction: 0.35), value: showUnlockBurst)
                        }

                        // UNLOCKED! text
                        Text("UNLOCKED! 🔓")
                            .font(.system(size: 36, weight: .black))
                            .foregroundColor(.white)
                            .scaleEffect(showUnlockBurst ? 1.0 : 0.3)
                            .opacity(showUnlockBurst ? 1.0 : 0.0)
                            .animation(.spring(response: 0.5, dampingFraction: 0.4).delay(0.1), value: showUnlockBurst)

                        // Opportunity title pill
                        Text(burstOppTitle)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color.cfDark)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.cfGold)
                            .cornerRadius(24)
                            .scaleEffect(showUnlockBurst ? 1.0 : 0.5)
                            .opacity(showUnlockBurst ? 1.0 : 0.0)
                            .animation(.spring(response: 0.5, dampingFraction: 0.45).delay(0.18), value: showUnlockBurst)

                        // Bouncing coins row
                        HStack(spacing: 16) {
                            ForEach(Array(["🪙","⭐️","🏅","⭐️","🪙xa4"].enumerated()), id: \.offset) { i, emoji in
                                Text(emoji)
                                    .font(.system(size: 28))
                                    .scaleEffect(showUnlockBurst ? 1.0 : 0.0)
                                    .offset(y: showUnlockBurst ? -6 : 6)
                                    .animation(
                                        .spring(response: 0.4, dampingFraction: 0.3)
                                        .delay(0.22 + Double(i) * 0.07),
                                        value: showUnlockBurst
                                    )
                            }
                        }
                    }
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.6).combined(with: .opacity),
                        removal:   .scale(scale: 1.3).combined(with: .opacity)
                    ))
                }
            }
        }
    }

    // MARK: Balance Banner
    private var balanceBanner: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 3) {
                Text("Your Wallet")
                    .font(Font.system(size: 12))
                    .foregroundColor(Color(red:0.3,green:0.3,blue:0.3))
                HStack(spacing: 6) {
                    Image(systemName: "dollarsign.circle.fill")
                        .font(Font.system(size: 20))
                        .foregroundColor(Color.cfGold)
                    Text("$\(appState.money)")
                        .font(Font.system(size: 26, weight: .bold))
                        .foregroundColor(Color.cfDark)
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 3) {
                Text("Unlocked")
                    .font(Font.system(size: 12))
                    .foregroundColor(Color(red:0.3,green:0.3,blue:0.3))
                Text("\(appState.unlockedOpportunityIDs.filter { !$0.hasPrefix("fc_") }.count) / \(allOpportunities.count)")
                    .font(Font.system(size: 18, weight: .bold))
                    .foregroundColor(Color.cfGreen)
            }
        }
        .padding(16)
        .background(Color.cfCard)
        .cornerRadius(16)
        .shadow(color: (Color.black as Color).opacity(0.07), radius: 8, y: 3)
        .padding(.horizontal, 16)
    }

    // MARK: Category Filter
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                OppFilterChip(label: "All", emoji: "✨", selected: selectedCategory == nil) {
                    selectedCategory = nil
                }
                ForEach(OppCategory.allCases, id: \.self) { cat in
                    OppFilterChip(
                        label: cat.rawValue,
                        emoji: cat.emoji,
                        selected: selectedCategory == cat,
                        color: cat.color
                    ) { selectedCategory = (selectedCategory == cat) ? nil : cat }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: List
    private var opportunityList: some View {
        VStack(spacing: 14) {
            ForEach(filtered) { opp in
                let unlocked = appState.unlockedOpportunityIDs.contains(opp.id)
                HTOppCard(opp: opp, unlocked: unlocked, canAfford: appState.money >= opp.cost) {
                    if unlocked { selectedOpp = opp }
                    else        { pendingOpp = opp; showUnlockAlert = true }
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Opportunity Card

struct HTOppCard: View {
    let opp: HTOpportunity
    let unlocked: Bool
    let canAfford: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(opp.category.color.opacity(0.12))
                        .frame(width: 58, height: 58)
                    Text(opp.category.emoji)
                        .font(Font.system(size: 28))
                    if unlocked {
                        VStack {
                            HStack {
                                Spacer()
                                ZStack {
                                    Circle().fill(Color.cfGreen).frame(width: 16, height: 16)
                                    Image(systemName: "lock.open.fill")
                                        .font(Font.system(size: 7, weight: .black))
                                        .foregroundColor(Color.white)
                                }
                            }
                            Spacer()
                        }
                        .frame(width: 58, height: 58)
                        .offset(x: 5, y: -5)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(opp.title)
                        .font(Font.system(size: 15, weight: .bold))
                        .foregroundColor(Color.cfDark)
                        .lineLimit(2)
                    Text(opp.organization)
                        .font(Font.system(size: 12))
                        .foregroundColor(Color(red:0.3,green:0.3,blue:0.3))
                    HStack(spacing: 6) {
                        Text(opp.amount)
                            .font(Font.system(size: 12, weight: .bold))
                            .foregroundColor(opp.category.color)
                        Text("•").foregroundColor(Color(red:0.3,green:0.3,blue:0.3)).font(Font.system(size: 10))
                        Text("Due: \(opp.deadline)")
                            .font(Font.system(size: 11))
                            .foregroundColor(Color(red:0.3,green:0.3,blue:0.3))
                    }
                }

                Spacer()

                if unlocked {
                    Image(systemName: "chevron.right.circle.fill")
                        .font(Font.system(size: 22))
                        .foregroundColor(opp.category.color)
                } else {
                    VStack(spacing: 2) {
                        Image(systemName: canAfford ? "lock.open" : "lock.fill")
                            .font(Font.system(size: 14))
                            .foregroundColor(canAfford ? Color.cfGold : Color.secondary)
                        Text("$\(opp.cost)")
                            .font(Font.system(size: 12, weight: .bold))
                            .foregroundColor(canAfford ? Color.cfGold : Color.secondary)
                    }
                }
            }
            .padding(14)
            .background(Color.cfCard)
            .cornerRadius(18)
            .shadow(color: (Color.black as Color).opacity(unlocked ? 0.08 : 0.05), radius: unlocked ? 10 : 7, y: 3)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(unlocked ? opp.category.color.opacity(0.3) : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Filter Chip

struct OppFilterChip: View {
    let label: String
    let emoji: String
    let selected: Bool
    var color: Color = Color.cfMaroon
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Text(emoji).font(Font.system(size: 12))
                Text(label)
                    .font(Font.system(size: 12, weight: .semibold))
                    .foregroundColor(selected ? Color.white : color)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(selected ? color : color.opacity(0.1))
            .cornerRadius(20)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Detail Sheet

struct OppDetailSheet: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    let opp: HTOpportunity
    let isUnlocked: Bool

    @State private var selectedTab = 0
    @State private var showAIChat  = false
    @State private var copiedEmail = false

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    oppHeader

                    Picker("", selection: $selectedTab) {
                        Text("Checklist").tag(0)
                        Text("Contact").tag(1)
                        Text("Email").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 16)

                    switch selectedTab {
                    case 0: checklistSection
                    case 1: contactSection
                    case 2: emailSection
                    default: EmptyView()
                    }

                    // AI Help button
                    Button { showAIChat = true } label: {
                        HStack(spacing: 10) {
                            Text("🤖").font(Font.system(size: 18))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Get AI Help with This Application")
                                    .font(Font.system(size: 15, weight: .bold))
                                    .foregroundColor(Color.white)
                                Text("Essay writing, pitch prep, questions answered")
                                    .font(Font.system(size: 12))
                                    .foregroundColor((Color.white as Color).opacity(0.8))
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor((Color.white as Color).opacity(0.8))
                        }
                        .padding(16)
                        .background(
                            LinearGradient(
                                colors: [Color.cfMaroon, Color(red: 0.65, green: 0.10, blue: 0.20)],
                                startPoint: .leading, endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: (Color.cfMaroon as Color).opacity(0.4), radius: 10, y: 4)
                        .padding(.horizontal, 16)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.top, 12)
                .padding(.bottom, 32)
            }
            .background(Color.cfBackground.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(opp.title)
                        .font(Font.system(size: 15, weight: .bold))
                        .foregroundColor(Color.cfDark)
                        .lineLimit(1)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .fullScreenCover(isPresented: $showAIChat) {
            OppAIChatView(opp: opp).environmentObject(appState)
        }
    }

    // MARK: Header
    private var oppHeader: some View {
        VStack(spacing: 12) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(opp.category.color.opacity(0.12))
                        .frame(width: 64, height: 64)
                    Text(opp.category.emoji).font(Font.system(size: 32))
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(opp.organization)
                        .font(Font.system(size: 13))
                        .foregroundColor(Color(red:0.3,green:0.3,blue:0.3))
                    Text(opp.amount)
                        .font(Font.system(size: 22, weight: .black))
                        .foregroundColor(opp.category.color)
                    HStack(spacing: 6) {
                        Image(systemName: "calendar").font(Font.system(size: 11)).foregroundColor(Color(red:0.3,green:0.3,blue:0.3))
                        Text("Deadline: \(opp.deadline)").font(Font.system(size: 12)).foregroundColor(Color(red:0.3,green:0.3,blue:0.3))
                    }
                }
                Spacer()
            }
            Text(opp.description)
                .font(Font.system(size: 14))
                .foregroundColor(Color(red:0.3,green:0.3,blue:0.3))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(Color.cfCard)
        .cornerRadius(16)
        .padding(.horizontal, 16)
    }

    // MARK: Checklist
    @ViewBuilder
    private var checklistSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Application Checklist")
                .font(Font.system(size: 16, weight: .bold))
                .foregroundColor(Color.cfDark)
            ForEach(Array(opp.applicationSteps.enumerated()), id: \.offset) { i, step in
                OppChecklistRow(number: i + 1, text: step)
            }
        }
        .padding(16)
        .background(Color.cfCard)
        .cornerRadius(16)
        .padding(.horizontal, 16)
    }

    // MARK: Contact
    @ViewBuilder
    private var contactSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Who to Contact")
                .font(Font.system(size: 16, weight: .bold))
                .foregroundColor(Color.cfDark)
            OppContactRow(icon: "person.fill",  label: "Contact", value: opp.contactName)
            OppContactRow(icon: "envelope.fill", label: "Email",   value: opp.contactEmail, copyable: true)
            OppContactRow(icon: "phone.fill",    label: "Phone",   value: opp.contactPhone,  copyable: true)

            Divider()

            Text("💡 Tips for reaching out")
                .font(Font.system(size: 14, weight: .semibold))
                .foregroundColor(Color.cfDark)
            Text("Include your student ID and year in every message. Be specific about what you need — advisors appreciate clear, concise emails.")
                .font(Font.system(size: 13))
                .foregroundColor(Color(red:0.3,green:0.3,blue:0.3))
        }
        .padding(16)
        .background(Color.cfCard)
        .cornerRadius(16)
        .padding(.horizontal, 16)
    }

    // MARK: Email
    @ViewBuilder
    private var emailSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Email Template")
                    .font(Font.system(size: 16, weight: .bold))
                    .foregroundColor(Color.cfDark)
                Spacer()
                Button {
                    UIPasteboard.general.string = opp.emailTemplate
                    withAnimation { copiedEmail = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation { copiedEmail = false }
                    }
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: copiedEmail ? "checkmark" : "doc.on.doc")
                            .font(Font.system(size: 12))
                        Text(copiedEmail ? "Copied!" : "Copy")
                            .font(Font.system(size: 13, weight: .semibold))
                    }
                    .foregroundColor(copiedEmail ? Color.cfGreen : Color.cfMaroon)
                    .padding(.horizontal, 12).padding(.vertical, 6)
                    .background(copiedEmail
                                ? (Color.cfGreen as Color).opacity(0.1)
                                : (Color.cfMaroon as Color).opacity(0.1))
                    .cornerRadius(10)
                }
            }
            Text("Fill in the [BRACKETS] with your information before sending.")
                .font(Font.system(size: 12))
                .foregroundColor(Color(red:0.3,green:0.3,blue:0.3))
            Text(opp.emailTemplate)
                .font(Font.system(size: 13, design: .monospaced))
                .foregroundColor(Color.cfDark)
                .padding(14)
                .background((Color.gray as Color).opacity(0.06))
                .cornerRadius(12)
        }
        .padding(16)
        .background(Color.cfCard)
        .cornerRadius(16)
        .padding(.horizontal, 16)
    }
}

// MARK: - Checklist Row

struct OppChecklistRow: View {
    let number: Int
    let text: String
    @State private var checked = false

    var body: some View {
        Button { withAnimation(.spring()) { checked.toggle() } } label: {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(checked ? Color.cfGreen : (Color.gray as Color).opacity(0.12))
                        .frame(width: 26, height: 26)
                    if checked {
                        Image(systemName: "checkmark")
                            .font(Font.system(size: 11, weight: .black))
                            .foregroundColor(Color.white)
                    } else {
                        Text("\(number)")
                            .font(Font.system(size: 11, weight: .bold))
                            .foregroundColor(Color(red:0.3,green:0.3,blue:0.3))
                    }
                }
                Text(text)
                    .font(Font.system(size: 14))
                    .foregroundColor(checked ? Color.secondary : Color.cfDark)
                    .strikethrough(checked, color: Color.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Contact Row

struct OppContactRow: View {
    let icon: String
    let label: String
    let value: String
    var copyable: Bool = false
    @State private var copied = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(Font.system(size: 14))
                .foregroundColor(Color.cfMaroon)
                .frame(width: 20)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(Font.system(size: 11))
                    .foregroundColor(Color(red:0.3,green:0.3,blue:0.3))
                Text(value)
                    .font(Font.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.cfDark)
            }
            Spacer()
            if copyable {
                Button {
                    UIPasteboard.general.string = value
                    withAnimation { copied = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation { copied = false }
                    }
                } label: {
                    Image(systemName: copied ? "checkmark.circle.fill" : "doc.on.doc")
                        .font(Font.system(size: 16))
                        .foregroundColor(copied ? Color.cfGreen : Color.cfMaroon)
                }
            }
        }
        .padding(12)
        .background((Color.gray as Color).opacity(0.05))
        .cornerRadius(10)
    }
}

// MARK: - Opportunity AI Chat

struct OppAIChatView: View {
    private let openRouterKey = "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"
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    let opp: HTOpportunity

    @State private var messages: [ChatMessage] = []
    @State private var inputText  = ""
    @State private var isLoading  = false
    @FocusState private var focused: Bool

    private var systemPrompt: String {
        """
        You are an AI application coach in the CampusFlow app for students at
        Huston-Tillotson University (an HBCU in Austin, TX).

        The student has unlocked this opportunity:
        Title: \(opp.title)
        Organization: \(opp.organization)
        Award: \(opp.amount)
        Deadline: \(opp.deadline)
        Contact: \(opp.contactName) at \(opp.contactEmail), \(opp.contactPhone)

        Help them specifically with:
        - Writing essays and personal statements for THIS opportunity
        - Preparing for interviews
        - Drafting professional emails to the contact listed above
        - Explaining any of the application steps
        - Any questions about this specific opportunity

        Be warm, encouraging, and practical. Keep responses focused and actionable.
        """
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Context banner
                HStack(spacing: 10) {
                    Text(opp.category.emoji).font(Font.system(size: 20))
                    VStack(alignment: .leading, spacing: 2) {
                        Text(opp.title)
                            .font(Font.system(size: 13, weight: .bold))
                            .foregroundColor(Color.cfDark)
                            .lineLimit(1)
                        Text("AI Application Coach — ready to help")
                            .font(Font.system(size: 11))
                            .foregroundColor(Color(red:0.3,green:0.3,blue:0.3))
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(opp.category.color.opacity(0.08))

                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 12) {
                            ForEach(messages) { msg in
                                OppChatBubble(message: msg, modeColor: opp.category.color).id(msg.id)
                            }
                            if isLoading { OppTypingIndicator(color: opp.category.color) }
                            Color.clear.frame(height: 8).id("btm")
                        }
                        .padding(16)
                    }
                    .onChange(of: messages.count) { _ in
                        withAnimation { proxy.scrollTo("btm") }
                    }
                }

                // Quick prompts
                if messages.count <= 1 {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(quickPrompts, id: \.self) { p in
                                Button {
                                    inputText = p
                                    sendMessage()
                                } label: {
                                    Text(p)
                                        .font(Font.system(size: 12, weight: .medium))
                                        .foregroundColor(opp.category.color)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(opp.category.color.opacity(0.08))
                                        .cornerRadius(12)
                                        .overlay(RoundedRectangle(cornerRadius: 12)
                                            .stroke(opp.category.color.opacity(0.2), lineWidth: 1))
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    }
                    .background(Color.cfCard.opacity(0.5))
                }

                Divider()

                // Input bar
                HStack(spacing: 10) {
                    ZStack(alignment: .leading) {
                        if inputText.isEmpty {
                            Text("Ask about this opportunity…")
                                .font(Font.system(size: 15))
                                .foregroundColor(Color(red:0.3,green:0.3,blue:0.3))
                                .padding(.horizontal, 14)
                        }
                        TextField("", text: $inputText, axis: .vertical)
                            .font(Font.system(size: 15))
                            .foregroundColor(Color.cfDark)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .focused($focused)
                            .lineLimit(1...4)
                    }
                    .background(Color.cfCard)
                    .cornerRadius(20)
                    .overlay(RoundedRectangle(cornerRadius: 20)
                        .stroke(opp.category.color.opacity(0.3), lineWidth: 1.5))

                    Button { sendMessage(); focused = false } label: {
                        ZStack {
                            Circle()
                                .fill(inputText.trimmingCharacters(in: .whitespaces).isEmpty
                                      ? (Color.gray as Color).opacity(0.2) : opp.category.color)
                                .frame(width: 42, height: 42)
                            Image(systemName: "arrow.up")
                                .font(Font.system(size: 16, weight: .bold))
                                .foregroundColor(inputText.trimmingCharacters(in: .whitespaces).isEmpty
                                                 ? Color.secondary : Color.white)
                        }
                    }
                    .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty || isLoading)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
            }
            .background(Color.cfBackground.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Application Helper")
                        .font(Font.system(size: 16, weight: .bold))
                        .foregroundColor(Color.cfDark)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .onAppear {
            messages.append(ChatMessage(
                role: .assistant,
                text: "I'm your AI coach for the \(opp.title) application! 🎯\n\nI can help with essays, interview prep, emails to \(opp.contactName), or anything about the application steps. What do you need?"
            ))
        }
    }

    private var quickPrompts: [String] {
        [
            "Help me write my personal statement",
            "Draft an email to \(opp.contactName)",
            "What should I highlight?",
            "What's the first step I should do?"
        ]
    }

    // MARK: - Instant answers for the opportunity AI chat
    private func instantAnswer(for text: String) -> String? {
        let lower = text.lowercased()
        let title = opp.title
        let contact = opp.contactName
        let email = opp.contactEmail
        let phone = opp.contactPhone
        let deadline = opp.deadline
        let amount = opp.amount
        let steps = opp.applicationSteps.enumerated().map { "\($0.offset + 1). \($0.element)" }.joined(separator: "\n")

        if lower.contains("first step") || lower.contains("where do i start") || lower.contains("how do i start") || lower.contains("what should i do first") {
            return """
            Here's exactly how to get started with \(title) 🚀

            Your first steps:
            \(steps)

            Deadline: \(deadline)
            Amount: \(amount)

            Start with step 1 today — don't wait until the deadline! Want me to help you write your personal statement or draft your first email?
            """
        }

        if lower.contains("email") && (lower.contains("write") || lower.contains("draft") || lower.contains("help") || lower.contains("template")) {
            return """
            Here's a ready-to-send email for \(title) 📧

            To: \(email)
            Subject: \(title) — Application Inquiry

            Dear \(contact),

            My name is [YOUR NAME], and I am a [YEAR] student at Huston-Tillotson University majoring in [MAJOR].

            I am writing to express my interest in the \(title) and to confirm the application requirements and deadline of \(deadline).

            Could you please let me know if there are any additional steps or documents needed beyond what is listed?

            Thank you for your time and support.

            Sincerely,
            [YOUR NAME]
            Student ID: [ID] | [PHONE NUMBER]

            ---
            Tap the Email tab in this opportunity for the full pre-written template — just fill in your [BRACKETS]!
            """
        }

        if lower.contains("personal statement") || lower.contains("essay") || lower.contains("write about myself") {
            return """
            Personal Statement Tips for \(title) ✍️

            Strong personal statements answer 3 questions:
            1. Who are you? (your background, your story)
            2. Why this opportunity? (specific reason for \(opp.organization))
            3. What will you do with it? (your goals, your impact)

            Opening line formula that works:
            "Growing up [your experience], I learned that [lesson]. That's why I'm applying for [opportunity]..."

            HT-specific angle that stands out:
            Mention your HBCU experience — what it means to attend HT, your community, first-gen status if applicable. \(opp.organization) specifically values HBCU students. Use that.

            Paste your draft here and I'll give you line-by-line feedback!
            """
        }

        if lower.contains("checklist") || lower.contains("requirements") || lower.contains("need to") || lower.contains("what do i need") {
            return """
            Here's your full checklist for \(title) ✅

            \(steps)

            Deadline: \(deadline)

            Pro tip: Work backwards from the deadline. If it's \(deadline), set your own deadline 2 weeks earlier to give time for review.

            Need help with any specific step? Just ask!
            """
        }

        if lower.contains("contact") || lower.contains("who do i") || lower.contains("phone") || lower.contains("call") || lower.contains("reach out") {
            return """
            Here's who to contact for \(title) 📬

            👤 \(contact)
            📧 \(email)
            📞 \(phone)

            Tips for reaching out:
            ✅ Email is usually faster than calling
            ✅ Always include your full name, student ID, and year
            ✅ Be specific — mention the opportunity name in the subject line
            ✅ Follow up after 5 business days if no response

            Want me to write the email for you? Just say "write me an email"!
            """
        }

        if lower.contains("deadline") || lower.contains("when is") || lower.contains("due date") || lower.contains("how long") {
            return """
            Key dates for \(title) 📅

            Deadline: \(deadline)
            Award: \(amount)

            ⚠️ Don't wait until the deadline — financial aid offices get flooded.
            Set a reminder for 2 weeks before and submit early.

            If you need a deadline extension, email \(contact) at \(email) as early as possible and explain your situation. They're more understanding than you think.
            """
        }

        if lower.contains("interview") || lower.contains("prepare") || lower.contains("preparation") {
            return """
            Interview Prep for \(title) 🎤

            Most common questions asked:
            1. "Tell me about yourself" — keep it 90 seconds, school → experience → goal
            2. "Why this scholarship/program?" — research \(opp.organization) specifically
            3. "What are your career goals?" — be specific, connect to what you'll do after HT
            4. "Tell me about a challenge you overcame" — use the STAR method

            STAR Method:
            • Situation — set the scene
            • Task — what was your responsibility
            • Action — what you specifically did
            • Result — what happened (use numbers if possible)

            Practice tip: Record yourself on your phone. Watching it back is uncomfortable but incredibly effective.

            Want me to do a mock interview with you? I'll ask you questions and give feedback!
            """
        }

        return nil
    }

    private func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty, !isLoading else { return }
        inputText = ""
        messages.append(ChatMessage(role: .user, text: text))

        // ── Instant answer — no network needed ──
        if let instant = instantAnswer(for: text) {
            messages.append(ChatMessage(role: .assistant, text: instant))
            return
        }

        isLoading = true

        Task {
            do {
                guard let url = URL(string: "https://openrouter.ai/api/v1/chat/completions") else { return }
                var req = URLRequest(url: url)
                req.httpMethod = "POST"
                req.setValue("application/json", forHTTPHeaderField: "Content-Type")
                req.setValue("Bearer \(openRouterKey)", forHTTPHeaderField: "Authorization")
                req.timeoutInterval = 30

                let systemMsg: [String: Any] = ["role": "system", "content": systemPrompt]
                let historyMsgs: [[String: Any]] = messages.map { msg in
                    ["role": msg.role == .user ? "user" : "assistant",
                     "content": msg.text]
                }
                var allMessages: [[String: Any]] = messages.map { msg in
                                   ["role": msg.role == .user ? "user" : "assistant",
                                    "content": msg.text]
                               }

                               // Prepend system prompt into first message for models that don't support system role
                               if allMessages.isEmpty {
                                   allMessages = [["role": "user", "content": systemPrompt]]
                               } else {
                                   let combined = systemPrompt + "\n\n" + ((allMessages[0]["content"] as? String) ?? "")
                                   allMessages[0] = ["role": "user", "content": combined]
                               }

                               let body: [String: Any] = [
                                   "model": "google/gemma-3n-e4b-it:free",
                                   "messages": allMessages,
                                   "max_tokens": 800
                               ]
               
                req.httpBody = try JSONSerialization.data(withJSONObject: body)

                let (data, response) = try await URLSession.shared.data(for: req)
                if let http = response as? HTTPURLResponse, http.statusCode != 200 {
                    let raw = String(data: data, encoding: .utf8) ?? "unknown"
                    throw NSError(domain: "OpenRouter", code: http.statusCode,
                                  userInfo: [NSLocalizedDescriptionKey: raw])
                }
                guard let json    = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let choices = json["choices"] as? [[String: Any]],
                      let message = choices.first?["message"] as? [String: Any],
                      let reply   = message["content"] as? String
                else {
                    throw NSError(domain: "OpenRouter", code: -1,
                                  userInfo: [NSLocalizedDescriptionKey: "Bad response"])
                }
                await MainActor.run {
                    messages.append(ChatMessage(role: .assistant, text: reply))
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    messages.append(ChatMessage(role: .assistant, text: "Connection issue. Check your internet and try again."))
                    isLoading = false
                }
            }
        }
    }

// MARK: - Chat Bubble (local copy — used by OppAIChatView)

struct OppChatBubble: View {
    let message: ChatMessage; let modeColor: Color
    var isUser: Bool { message.role == .user }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isUser { Spacer(minLength: 44) }
            if !isUser {
                ZStack {
                    Circle().fill(modeColor.opacity(0.15)).frame(width: 32, height: 32)
                    Text("🤖").font(Font.system(size: 16))
                }
            }
            VStack(alignment: isUser ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .font(Font.system(size: 15))
                    .foregroundColor(isUser ? Color.white : Color.cfDark)
                    .padding(.horizontal, 14).padding(.vertical, 10)
                    .background(isUser ? modeColor : Color.cfCard)
                    .cornerRadius(18)
                Text(timeString(message.timestamp))
                    .font(Font.system(size: 10)).foregroundColor(Color(red:0.3,green:0.3,blue:0.3))
            }
            if !isUser { Spacer(minLength: 44) }
        }
    }

    private func timeString(_ date: Date) -> String {
        let f = DateFormatter(); f.timeStyle = .short; return f.string(from: date)
    }
}

// MARK: - Typing Indicator (local copy)

struct OppTypingIndicator: View {
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
            .background(Color.cfCard).cornerRadius(18)
            Spacer()
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.4).repeatForever().delay(0.00)) { dot1.toggle() }
            withAnimation(.easeInOut(duration: 0.4).repeatForever().delay(0.15)) { dot2.toggle() }
            withAnimation(.easeInOut(duration: 0.4).repeatForever().delay(0.30)) { dot3.toggle() }
        }
    }
}

// MARK: - Unlock Burst Animation

struct UnlockBurstView: View {
    let title: String
    @State private var phase: Int = 0

    var body: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()

            // Expanding rings
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .stroke(Color.cfGold.opacity(0.3 - Double(i) * 0.08), lineWidth: 2)
                    .frame(width: CGFloat(120 + i * 70), height: CGFloat(120 + i * 70))
                    .scaleEffect(phase >= 1 ? 1.0 : 0.1)
                    .animation(
                        .spring(response: 0.5, dampingFraction: 0.6)
                        .delay(Double(i) * 0.08),
                        value: phase
                    )
            }

            VStack(spacing: 20) {

                // Lock icon with shake then open
                ZStack {
                    Circle()
                        .fill(Color.cfGold.opacity(0.18))
                        .frame(width: 110, height: 110)
                        .scaleEffect(phase >= 1 ? 1.0 : 0.2)
                        .animation(.spring(response: 0.4, dampingFraction: 0.55), value: phase)

                    Image(systemName: phase >= 2 ? "lock.open.fill" : "lock.fill")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(Color.cfGold)
                        .scaleEffect(phase >= 1 ? 1.0 : 0.1)
                        .rotationEffect(.degrees(phase == 1 ? -15 : 0))
                        .animation(.spring(response: 0.35, dampingFraction: 0.5), value: phase)
                }

                // UNLOCKED text
                Text("UNLOCKED!")
                    .font(.system(size: 34, weight: .black))
                    .foregroundColor(.white)
                    .scaleEffect(phase >= 2 ? 1.0 : 0.4)
                    .opacity(phase >= 2 ? 1.0 : 0.0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.6).delay(0.15), value: phase)

                // Opportunity title
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color.cfGold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .opacity(phase >= 2 ? 1.0 : 0.0)
                    .offset(y: phase >= 2 ? 0 : 10)
                    .animation(.easeOut(duration: 0.3).delay(0.25), value: phase)

                // Floating coins row
                HStack(spacing: 14) {
                    ForEach(Array(["🪙","⭐️","🏅","⭐️","🪙"].enumerated()), id: \.offset) { i, emoji in
                        Text(emoji)
                            .font(.system(size: 26))
                            .offset(y: phase >= 2 ? -10 : 10)
                            .opacity(phase >= 2 ? 1.0 : 0.0)
                            .animation(
                                .easeInOut(duration: 0.55)
                                .repeatForever(autoreverses: true)
                                .delay(Double(i) * 0.1),
                                value: phase
                            )
                    }
                }
                .padding(.top, 4)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { phase = 1 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { phase = 2 }
        }
        .transition(.asymmetric(
            insertion: .opacity.combined(with: .scale(scale: 0.85)),
            removal:   .opacity.combined(with: .scale(scale: 1.15))
        ))
    }
}

}
