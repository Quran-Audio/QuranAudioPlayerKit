//
//  DownnloadCell.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 24/01/22.
//

import SwiftUI

struct DownloadQueueView: View {
    @ObservedObject var viewModel = DownloadQueueViewModel()
    @State var showToast:Bool = false
    @State var toastDescription:String = ""
    @State var toastType:ToastView.ToasType = .warning
    var padding:CGFloat = 5
    var lineWidth:CGFloat = 5
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing:0) {
                    if viewModel.downloadQueue.count > 0 {
                        circularProgress
                            .frame(height:150)
                        VStack(spacing:10) {
                            title
                            buttonPanel
                        }
                        Spacer(minLength: 10)
                        Divider()
                        Spacer(minLength: 20)
                        ScrollView {
                            VStack(spacing:1) {
                                Section("Download Queue".localize){
                                    ForEach(viewModel.downloadQueue, id: \.index) { chapter in
                                        DownloadQueueCell(viewModel: viewModel,
                                                          chapter:chapter)
                                    }
                                }
                            }
                        }
                    }else {
                        Spacer(minLength: 20)
                        Text("Empty Download queue".localize)
                    }
                    Spacer()
                }
            }
            .foregroundColor(ThemeService.themeColor)
            .toast(showToast: $showToast,
                   title: "Warning".localize,
                   description: toastDescription,
                   type: $toastType,
                   alignment: .center)

        }
        .foregroundColor(Color(uiColor: .label))
        .navigationTitle("Download Manager".localize)
        
    }
    
    struct DownloadQueueCell: View {
        @ObservedObject var viewModel:DownloadQueueViewModel
        var chapter:ChapterModel
        var body: some View {
            HStack {
                ZStack {
                    Rectangle()
                        .fill(ThemeService.themeColor.opacity(0.1))
                        .frame(height: 70)
                    HStack {
                        ZStack {
                            Rectangle()
                                .fill(ThemeService.themeColor.opacity(0.2))
                                .frame(width: 40, height: 70, alignment: .leading)
                            
                            Text("\(chapter.index)")
                                .foregroundColor(Color(UIColor.label.withAlphaComponent(0.5)))
                                .font(.system(size: 17))
                        }
                        VStack(alignment:.leading, spacing: 5) {
                            Text(chapter.name)
                                .font(ThemeService.shared.arabicFont(size: 17))
                                .foregroundColor(Color(UIColor.label))
                            Text(chapter.nameTrans)
                                .font(.system(size: 15))
                                .foregroundColor(Color(UIColor.secondaryLabel))
                        }
                        Spacer()
                        Text("\(chapter.size)B")
                            .foregroundColor(ThemeService.themeColor.opacity(0.8))
                            .font(.system(size: 15))
                        Button {
                            viewModel.removeFromDownloadQueueList(chapter: chapter)
                        } label: {
                            Image(systemName: "xmark.circle")
                                .font(.system(size: 20))
                                .foregroundColor(ThemeService.red)
                                .padding(.horizontal)
                        }.frame(width: 44, height: 55)
                    }
                }
                .background(Color(UIColor.systemBackground))
                
            }.foregroundColor(ThemeService.themeColor)
                .padding(.horizontal,7)
            
        }
    }
    @ViewBuilder var buttonPanel:some View {
        HStack(spacing:0) {
            Button {
                if viewModel.isConnectedToNetwork {
                    viewModel.startDownload()
                }else {
                    if let description = viewModel.connectionAlertMessage {
                        self.toastDescription = description
                        showToast = true
                    }
                    
                }
            } label: {
                Image(systemName: viewModel.isDownloading ? "pause":"play")
                    .font(.system(size: 25))
                    .foregroundColor(ThemeService.themeColor.opacity(0.9))
                    .padding(.horizontal)
            }
            Button {
                viewModel.cancelDownload()
            } label: {
                Image(systemName: "xmark.circle")
                    .font(.system(size: 20))
                    .foregroundColor(ThemeService.red)
                    .padding(.horizontal)
            }
        }
    }
    
    @ViewBuilder var circularProgress: some View {
        GeometryReader { geometry in
            ZStack {
                let radius = min(geometry.size.width/2,geometry.size.height/2) - padding - lineWidth
                let midPoint = CGPoint(x: geometry.size.width/2,
                                       y: geometry.size.height/2)
                Path { path in
                    path.addArc(center: midPoint,
                                radius: radius,
                                startAngle: Angle(degrees: 0),
                                endAngle: Angle(degrees: 360),
                                clockwise: false)
                }.stroke(ThemeService.red.opacity(0.1), style: StrokeStyle(lineWidth: lineWidth + 2,
                                                               lineCap: .square,
                                                               lineJoin: .bevel))
                Path { path in
                    path.addArc(center: midPoint,
                                radius: radius,
                                startAngle: Angle(degrees: 0 - 90),
                                endAngle: Angle(degrees:  viewModel.progressInPi - 90),
                                clockwise: false)
                }.stroke(.green, style: StrokeStyle(lineWidth: lineWidth,
                                                    lineCap: .round,
                                                    lineJoin: .bevel))
                
                Text(String(format: "%.1f %%", viewModel.progress*100))
                    .font(.system(size: 20))
            }
        }
    }
    
    @ViewBuilder var title: some View {
        VStack{
            Text(viewModel.chapterName)
                .font(ThemeService.shared.arabicFont(size: 20))
                .foregroundColor(ThemeService.themeColor)
            Text(viewModel.chapterTrans)
                .font(ThemeService.shared.translationFont(size: 20))
                .foregroundColor(ThemeService.themeColor.opacity(0.7))
        }
    }
}

struct DownnloadCell_Previews: PreviewProvider {
    static var previews: some View {
        DownloadQueueView()
    }
}
