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
                VStack {
                    // ─────────────────────────────────────────────────────
                    // 기존 상단 헤더 (수정 없음)
                    HStack(spacing: 8) {
                        Image(.logo)
                            .frame(width: 23, height: 26)
                        Text("ANON")
                            .font(.arialBlack(size: 22))
                    }
                    ScrollView { // 내용이 늘어나므로 스크롤 가능
                        VStack(spacing: 16) {
                            
                            HStack(spacing: 20) {
                                VStack(spacing: 29) {
                                    Text("Tasks to watch")
                                        .font(.labelM)
                                        .foregroundStyle(.neutral70)
                                    
                                    VStack(spacing: 4) {
                                        // 1등: 가장 위험한 작업
                                        HStack(spacing: 0) {
                                            Text("1. ")
                                                .font(.b1)
                                                .foregroundStyle(.neutral100)
                                            Text(topThree.first?.process ?? "—")
                                                .font(.b1)
                                                .foregroundStyle(.neutral100)
                                        }
                                        // 2등: 두 번째로 위험한 작업
                                        HStack(spacing: 0) {
                                            Text("2. ")
                                                .font(.b1)
                                                .foregroundStyle(.neutral100)
                                            Text(topThree.dropFirst().first?.process ?? "—")
                                                .font(.b1)
                                                .foregroundStyle(.neutral100)
                                        }
                                        // 3등: 세 번째로 위험한 작업
                                        HStack(spacing: 0) {
                                            Text("3. ")
                                                .font(.b1)
                                                .foregroundStyle(.neutral100)
                                            Text(topThree.dropFirst(2).first?.process ?? "—")
                                                .font(.b1)
                                                .foregroundStyle(.neutral100)
                                        }
                                    }
                                }
                                .padding(.vertical, 24)
                                .padding(.leading, 24)
                                
                                Rectangle()
                                    .frame(width: 98, height: 1)
                                    .foregroundStyle(.neutral20)
                                
                                VStack(spacing: 43) {
                                    Text("Today’s Risk Score")
                                        .font(.labelM)
                                        .foregroundStyle(.neutral70)
                                    
                                    HStack(spacing: 4) {
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
                            .onTapGesture {
                                container.navigationRouter.push(to: .taskRiskListView)
                            }
                            .navigationDestination(for: NavigationDestination.self) { destination in
                                NavigationRoutingView(destination: destination)
                                    .environmentObject(container)
                                    .environmentObject(appFlowViewModel)
                            }
                            
                            
                            // ─────────────────────────────────────────────────────
                            
                            // ⬇️ [추가] Today’s Checklist
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Today’s Checklist")
                                    .font(.labelM)
                                    .foregroundStyle(.neutral70)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                VStack(spacing: 12) {
                                    ForEach(todayTasks) { task in
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
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 24)
                            
                            // SwiftData 초기화 버튼
                            VStack(spacing: 16) {
                                Button(action: {
                                    showingResetAlert = true
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "trash.circle.fill")
                                            .foregroundColor(.red)
                                            .font(.title2)
                                        
                                        Text("SwiftData 초기화")
                                            .foregroundColor(.red)
                                            .fontWeight(.semibold)
                                    }
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 20)
                                    .background(Color.red.opacity(0.1))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.red.opacity(0.3), lineWidth: 1)
                                    )
                                }
                                
                                Text("모든 저장된 작업 데이터가 삭제됩니다")
                                    .font(.caption)
                                    .foregroundColor(.neutral60)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 32)
                        }
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
        .overlay(
            // 플러스 버튼을 우측 하단에 배치
            VStack {
                Spacer()
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
        )
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

// MARK: - Task Row Card (접힘/펼침)
private struct TaskRowCard: View {
    let task: ConstructionTask
    @Binding var isExpanded: Bool
    
    // 더미 체크리스트 (실제 항목 연결 전까지 임시)
    private var sampleChecks: [(title: String, desc: String, done: Bool)] {
        [
            ("지하매설물 조사", "가스관, 상하수도관, 전기·통신케이블관 등의 매설 유무", true),
            ("지하매설물 조사", "가스관, 상하수도관, 전기·통신케이블관 등의 매설 유무", true)
        ]
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 상단 행
            HStack(alignment: .top) {
                // 좌측 상태 점 (리스크에 따라 색 조절 예시)
                Circle()
                    .fill(dotColor(for: task.riskScore))
                    .frame(width: 10, height: 10)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(task.process) // 공정명
                        .font(.h5)
                        .foregroundStyle(.neutral100)
                    
                    Text(MainView.timeFormatter.string(from: task.startTime))
                        .font(.b2)
                        .foregroundStyle(.neutral60)
                }
                
                Spacer()
                
                if isExpanded {
                    Text("Done")
                        .font(.labelM)
                        .foregroundStyle(.blue60)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            Capsule().fill(Color.blue5)
                        )
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isExpanded = false     // 접기
                            }
                        }
                } else {
                    // 진행 개수 배지 (샘플: "2 / 3" 같은 모양)
                    let progressNumerator = max(1, task.progressRate / 40)
                    let progressDenominator = max(1, task.progressRate / 30)
                    Text("\(progressNumerator) / \(progressDenominator)")
                        .font(.b2)
                        .foregroundStyle(.neutral80)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            Capsule().fill(Color.neutral10)
                        )
                }
            }
            .contentShape(Rectangle()) // 탭 영역 확장
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, isExpanded ? 10 : 14)
            
            // 펼친 내용
            if isExpanded {
                VStack(spacing: 20) {
                    ForEach(Array(sampleChecks.enumerated()), id: \.offset) { _, item in
                        HStack(alignment: .top, spacing: 12) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(item.title)
                                    .font(.labelM)
                                    .foregroundStyle(.neutral100)
                                Text(item.desc)
                                    .font(.b2)
                                    .foregroundStyle(.neutral70)
                            }
                            Spacer()
                            Image(systemName: "checkmark.square.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 22)
                                .foregroundStyle(.blue60)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        
        .background(
            RoundedRectangle(cornerRadius: 12).fill(Color.neutral10)
        )
    }
    
    private func dotColor(for score: Int) -> Color {
        switch score {
        case 0..<40:  return .green
        case 40..<70: return .yellow
        default:      return .red
        }
    }
}
