import SwiftUI
import SwiftData

struct MainView: View {
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    @Environment(\.modelContext) private var modelContext
    
    // 오늘 범위
    private let startOfToday: Date
    private let endOfToday: Date
    
    // 오늘 작업들 – 시작시간 오름차순
    @Query private var todayTasks: [ConstructionTask]
    
    // 오늘 작업들 – riskScore 내림차순 (순위용)
    @Query private var rankedToday: [ConstructionTask]
    
    // ✅ 탭해서 펼친 카드 추적
    @State private var expandedTaskID: UUID? = nil
    
    // ✅ SwiftData 초기화 관련
    @State private var showingResetAlert: Bool = false
    
    init() {
        let cal = Calendar.current
        let start = cal.startOfDay(for: Date())
        let end   = cal.date(byAdding: .day, value: 1, to: start)!   // 내일 0시
        self.startOfToday = start
        self.endOfToday = end
        
        _todayTasks = Query(
            filter: #Predicate<ConstructionTask> {
                $0.startTime >= start && $0.startTime < end
            },
            sort: [SortDescriptor(\.startTime, order: .forward)]
        )
        
        _rankedToday = Query(
            filter: #Predicate<ConstructionTask> {
                $0.startTime >= start && $0.startTime < end
            },
            sort: [SortDescriptor(\.riskScore, order: .reverse)]
        )
    }
    
    // ✅ topThree: 오늘 작업을 riskScore 순으로 3개
    private var topThree: [ConstructionTask] {
        Array(rankedToday.prefix(3))
    }
    
    // ✅ averageRisk: 오늘 작업들의 riskScore 평균
    private var averageRisk: Int {
        guard !todayTasks.isEmpty else { return 0 }
        let total = todayTasks.reduce(0) { $0 + $1.riskScore }
        return Int((Double(total) / Double(todayTasks.count)).rounded())
    }
    
    // 시간 포맷터
    static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .none
        f.timeStyle = .short    // "8:00 AM"
        return f
    }()
    
    var body: some View {
        NavigationStack(path: $container.navigationRouter.destination) {
            ZStack {
                Color(hex: "F2F2F8")
                    .ignoresSafeArea(edges: .all)
                VStack(spacing: 16) {
                    LogoHeaderSection()
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            RiskScoreSection(
                                            topThree: topThree,
                                            averageRisk: averageRisk
                                        ) {
                                            container.navigationRouter.push(to: .taskRiskListView)
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.bottom, 16)
                                        .navigationDestination(for: NavigationDestination.self) { destination in
                                            NavigationRoutingView(destination: destination)
                                                .environmentObject(container)
                                                .environmentObject(appFlowViewModel)
                                        }
                                        
                            
                            
                            // ─────────────────────────────────────────────────────
                            

                            Text("Today’s Checklist")
                                    .font(.labelM)
                                    .foregroundStyle(.neutral70)
                                    .padding(.horizontal, 16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                            VStack(spacing: 0) {
                                ForEach(Array(todayTasks.enumerated()), id: \.element.id) { index, task in
                                    TaskRowCard(
                                        task: task,
                                        isExpanded: Binding(
                                            get: { expandedTaskID == task.id },
                                            set: { newValue in
                                                withAnimation(.easeInOut(duration: 0.2)) {
                                                    expandedTaskID = newValue ? task.id : nil
                                                }
                                            }
                                        )
                                    )
                                    if index < todayTasks.count - 1 {
                                        Divider()
                                            .padding(.leading, 16)
                                    }
                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 12).fill(.white)
                            )
                            .padding(.horizontal, 16)
                            .padding(.bottom, 75)


                        }
                    }
                    
                    // 플러스 버튼을 우측 하단에 배치
                    HStack {
                        Spacer()
                        PlusButton(action: {
                            // 플러스 버튼을 누르면 테스크 추가 화면으로 이동
                            appFlowViewModel.appState = .addTask
                        })
                        .frame(width: 48, height: 48)
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                    
                }
                
            }
        }
        .alert("SwiftData 초기화", isPresented: $showingResetAlert) {
            Button("취소", role: .cancel) { }
            Button("초기화", role: .destructive) {
                resetSwiftData()
            }
        } message: {
            Text("모든 저장된 작업 데이터가 삭제됩니다.\n이 작업은 되돌릴 수 없습니다.")
        }
        .navigationDestination(for: NavigationDestination.self) { destination in
            NavigationRoutingView(destination: destination)
                .environmentObject(container)
                .environmentObject(appFlowViewModel)
        }
    }
    
    // MARK: - SwiftData 초기화
    private func resetSwiftData() {
        do {
            // 모든 ConstructionTask 삭제
            try modelContext.delete(model: ConstructionTask.self)
            
            // 변경사항 저장
            try modelContext.save()
            
            print("✅ SwiftData 초기화 완료")
        } catch {
            print("❌ SwiftData 초기화 실패: \(error)")
        }
    }
}

// MARK: - LogoHeaderSection

fileprivate struct LogoHeaderSection: View {
    var body: some View {
        Image(.textLogo)
            .scaledToFit()
            .frame(height: 30)
            .padding(.leading, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Risk Score Section (오늘의 리스크 카드)

fileprivate struct RiskScoreSection: View {
    let topThree: [ConstructionTask]
    let averageRisk: Int
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            VStack(spacing: 29) {
                Text("Tasks to watch")
                    .font(.labelM)
                    .foregroundStyle(.neutral70)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: 4) {
                    // 1등
                    HStack {
                        Text("1. ")
                            .font(.b1)
                            .foregroundStyle(.neutral100)
                        +
                        Text(topThree.first?.process ?? "Concrete pour")
                            .font(.b1)
                            .foregroundStyle(.neutral100)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // 2등
                    HStack {
                        Text("2. ")
                            .font(.b1)
                            .foregroundStyle(.neutral100)
                        +
                        Text(topThree.dropFirst().first?.process ?? "rebar, tie-in")
                            .font(.b1)
                            .foregroundStyle(.neutral100)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.vertical, 24)
            .padding(.leading, 24)
            
            Rectangle()
                .frame(width: 1, height: 98)
                .foregroundStyle(.neutral20)
            
            VStack(spacing: 43) {
                Text("Today’s Risk Score")
                    .font(.labelM)
                    .foregroundStyle(.neutral70)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(alignment: .bottom, spacing: 4) {
                    Text("\(averageRisk)")
                        .font(.pretendard(type: .medium, size: 48))
                        .foregroundStyle(.neutral100)
                    
                    Text("pts")
                        .font(.h4)
                        .foregroundStyle(.neutral100)
                }
            }
            .padding(.vertical, 24)
            .padding(.trailing, 24)
        }
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.neutral0)
        }
        .onTapGesture { onTap() }
    }
}

