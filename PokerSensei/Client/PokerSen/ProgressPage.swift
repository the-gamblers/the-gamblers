import SwiftUI

struct ProgressPage: View {
    @State private var selectedTimeFrame: TimeFrame = .sevenDays

    enum TimeFrame: String, CaseIterable {
        case sevenDays = "7 days"
        case thirtyDays = "30 days"
        case allTime = "All Time"
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Background image
                Image("background-pic")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.5) // Adjust the opacity as needed

                // Content with white rounded rectangle background
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.white)
                                .shadow(radius: 5)

                            VStack {
                                HStack {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                    Text("username00")
                                        .font(.title2)
                                    Spacer()
                                }
                                .padding(.horizontal)
                                .padding(.top, 20)

                                Picker("Timeframe", selection: $selectedTimeFrame) {
                                    ForEach(TimeFrame.allCases, id: \.self) { timeframe in
                                        Text(timeframe.rawValue).tag(timeframe)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding()

                                VStack(alignment: .leading) {
                                    Text("Wins: 4")
                                    Text("Losses: 7")
                                    Text(" ")
                                }
                                .padding(.leading)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 30)
//                        .padding(.bottom, 20)
                    }
                }
                .navigationTitle("Progress Page")
            }
        }
    }
}

// ... other view structs like HistoryRow, SectionHeader, etc., remain the same ...

struct ProgressPage_Previews: PreviewProvider {
    static var previews: some View {
        ProgressPage()
    }
}
