//
//  AddTaskView.swift
//  Anon
//
//  Created by 김성현 on 2025-08-24.
//

import SwiftUI
import SwiftData

struct AddTaskView: View {
    // 모델 컨텍스트 (필요시 편집/삭제 등에 사용)
    @EnvironmentObject var container: DIContainer
    @Environment(\.modelContext) private var modelContext

    // 오늘의 시작/끝 (로컬 캘린더 기준)
    private let startOfToday: Date
    private let endOfToday: Date

    // 오늘 작업만, 시작 시간이 빠른 순으로 정렬
    @Query private var tasks: [ConstructionTask]

    init() {
        let cal = Calendar.current
        let now = Date()
        startOfToday = cal.startOfDay(for: now)
        endOfToday   = cal.date(byAdding: .day, value: 1, to: startOfToday)!  // 내일 0시

        // SwiftData @Query 는 init 에서 동적으로 구성할 수 있어요
        _tasks = Query(
            filter: #Predicate<ConstructionTask> {
                $0.startTime >= startOfToday && $0.startTime < endOfToday
            },
            sort: [SortDescriptor(\.startTime, order: .forward)]
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(tasks) { task in
                    TaskCard(task: task)
                }
                .padding(.bottom, 20)

                // + 버튼 (추가 액션은 원하는 동작으로 연결)
                Button {
                    // TODO: 새 작업 추가 흐름으로 이동
                    container.navigationRouter.popToRooteView()
                    container.navigationRouter.push(to: .processAddView(taskId: ""))
                } label: {
                    ZStack {
                        Circle()
                            .fill(.blue5)
                            .stroke(.blue10, lineWidth: 4)
                        Image(.addIcon)
                            .frame(width: 24, height: 24)
                    }
                    .frame(width: 48, height: 48)
                }
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
    }
}

private struct TaskCard: View {
    let task: ConstructionTask

    private var timeString: String {
        let f = DateFormatter()
        f.dateStyle = .none
        f.timeStyle = .short   // "2:00 PM"
        return f.string(from: task.startTime)
    }

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 7) {
                // 상단 타이틀: 공정/프로세스 (원하는 조합으로 표기)
                Text(task.process) // 예: "마감, 도장"
                    .font(.h5)
                    .foregroundStyle(.neutral100)

                // 하단 메타: 시간 / 인원
                HStack(spacing: 0) {
                    Text(timeString)
                    + Text(" / ")
                        .foregroundStyle(.secondary)
                    + Text("\(task.workers) workers")
                }
                .font(.b2)
                .foregroundStyle(.neutral60)
            }

            Spacer()

            // 진행률
            Text("\(task.progressRate)%")
                .font(.h4)
                .foregroundStyle(.neutral100)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.neutral10)
        )
    }
}
