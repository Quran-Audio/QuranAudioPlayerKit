//
//  ChapterListView.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 15/01/22.
//

import SwiftUI

struct ChapterListView: View {
    @ObservedObject var viewModel = ChapterListViewModel()
    @ObservedObject var playerCellViewModel = PlayerCellViewModel()
    @State var showingDownloadSheet:Bool = false
    @State var showingSettingsSheet:Bool = false
    @State var fullPlayerFrameHeight:CGFloat = 0
    @State var fullPlayerOpacity:CGFloat = 0
    @State var showToast:Bool = false
    @State var toastTitle:String = ""
    @State var toastDescriptiom:String = ""
    @State var toastType:ToastView.ToasType = .info
    @State var onToastConfirm:(() -> Void)?
    
    var body: some View {
        VStack {
            ZStack(alignment:.bottom) {
                VStack(spacing:0)  {
                    ScrollView {
                        if viewModel.chapters.count == 0 {
                            Spacer(minLength: 20)
                            emptyListView
                            Spacer()
                        }else {
                            chapterListView
                        }
                    }
                    if AudioService.shared.isCurrentChapterAvailable() {
                        PlayerCellView(viewModel: playerCellViewModel)
                            .onTapGesture {
                                fullPlayerFrameHeight = 250
                                fullPlayerOpacity = 1
                            }
                    }
                    TabBarView(viewModel: viewModel)
                        .background(ThemeService.themeColor)
                }
                FullPlayerView(frameHeight: $fullPlayerFrameHeight,
                               opacity:$fullPlayerOpacity)
            }.navigatorView(title: "Quran") {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    Button {
                        print("Download Button")
                        showingDownloadSheet = true
                    } label: {
                        Image(systemName: "icloud.and.arrow.down")
                            .font(.system(size: 20))
                    }
                    .sheet(isPresented: $showingDownloadSheet) {
                        showingDownloadSheet = false
                    } content: {
                        DownloadQueueView()
                    }
                }else {
                    NavigationLink(destination: DownloadQueueView()) {
                        Image(systemName: "icloud.and.arrow.down")
                            .font(.system(size: 22))
                    }
                }
            } rightItems: {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    Button {
                        print("Settings Button")
                        showingSettingsSheet = true
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.system(size: 20))
                    }
                    .sheet(isPresented: $showingSettingsSheet) {
                        showingSettingsSheet = false
                    } content: {
                        SettingsView()
                    }
                }else {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                            .font(.system(size: 20))
                    }
                }
            }
            
        }
        .background(ThemeService.themeColor)
        .toast(showToast: $showToast,
               title: toastTitle,
               description: toastDescriptiom,
               type: $toastType,
               onConfirm: onToastConfirm)
    }
    
    //MARK: View Builders
    @ViewBuilder private var emptyListView: some View {
        VStack {
            HStack {
                Spacer()
                if viewModel.listType == .downloads {
                    Text("Empty Download List")
                }else if viewModel.listType == .favourites {
                    Text("Empty Favourites List")
                }
                Spacer()
            }
            Spacer()
        }
    }
    
    @ViewBuilder private var chapterListView: some View {
        VStack(spacing:10) {
            Spacer(minLength: 5)
            ForEach(viewModel.chapters, id: \.index) { chapter in
                ChapterCell(onFavourite: { chapter in
                    
                    if viewModel.isFavourite(chapter: chapter) {
                        toastType = .info
                        toastTitle = "Removed from favourites"
                        toastDescriptiom = ""
                    }else {
                        toastType = .info
                        toastTitle = "Added to favourites"
                        toastDescriptiom = ""
                    }
                    self.showToast = true
                    viewModel.onFavouriteChapter(chapterIndex: chapter.index)
                },
                            onDownload: { chapter in
                    if viewModel.isDownloaded(chapter: chapter) {
                        toastType = .alert
                        toastTitle = "Warning"
                        toastDescriptiom = "Permanently delete the file?"
                        self.showToast = true
                        onToastConfirm = {
                            viewModel.deleteChapter(chapter: chapter)
                            self.showToast = false
                        }
                    }else {
                        toastType = .info
                        toastTitle = "Added to download queue."
                        viewModel.addToDownloadQueue(chapter: chapter)
                        toastDescriptiom = ""
                        self.showToast = true
                    }
                    
                },
                            chapter: chapter)
                    .contentShape(Rectangle())
                    .onTapGesture {
                    self.viewModel.setCurrent(chapter: chapter)
                }
            }
            Spacer(minLength: 5)
        }
        .background(ThemeService.whiteColor)
    }
    
    
    struct TabBarView: View {
        @ObservedObject var viewModel:ChapterListViewModel
        var body: some View {
            HStack(spacing:0) {
                ZStack {
                    Rectangle()
                    VStack {
                        Image(systemName: "house.fill")
                            .font(.system(size: 23))
                        Text("Home")
                            .font(.system(size: 15))
                    }.foregroundColor(viewModel.listType == .all ? ThemeService.whiteColor : ThemeService.borderColor.opacity(0.7))
                }.onTapGesture {
                    if viewModel.listType != .all {
                        viewModel.listType = .all
                    }
                }
                ZStack {
                    Rectangle()
                    VStack {
                        Image(systemName: "square.and.arrow.down.fill")
                            .font(.system(size: 23))
                        Text("Downloads")
                            .font(.system(size: 15))
                    }.foregroundColor(viewModel.listType == .downloads ? ThemeService.whiteColor : ThemeService.borderColor.opacity(0.7))
                }.onTapGesture {
                    if viewModel.listType != .downloads {
                        viewModel.listType = .downloads
                    }
                }
                ZStack {
                    Rectangle()
                    VStack {
                        Image(systemName: "star.fill")
                            .font(.system(size: 23))
                        Text("Favourites")
                            .font(.system(size: 13))
                    }.foregroundColor(viewModel.listType == .favourites ? ThemeService.whiteColor : ThemeService.borderColor.opacity(0.7))
                }.onTapGesture {
                    if viewModel.listType != .favourites {
                        viewModel.listType = .favourites
                    }
                }
            }
            .foregroundColor(ThemeService.themeColor)
            .frame(height: 60)
            .background(ThemeService
                            .themeColor
                            .ignoresSafeArea(edges:.bottom))
        }
    }
    
    
}

struct ChapterListView_Previews: PreviewProvider {
    static var previews: some View {
        ChapterListView()
        //.previewInterfaceOrientation(.landscapeLeft)
    }
}
