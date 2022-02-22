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
    @State var showFullPlayer: Bool = false
    @State var navigateChapterSelection: Int? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack(alignment:.bottom) {
                    VStack(spacing:0)  {
                        if viewModel.chapters.count == 0 {
                            Spacer(minLength: 20)
                            emptyListView
                            Spacer()
                        }else {
                            chapterListView
                        }
                        
                        if AudioService.shared.isCurrentChapterAvailable() {
                            if TargetDevice.currentDevice != .nativeMac {
                                PlayerCellView(viewModel: playerCellViewModel)
                                    .onTapGesture {
                                        showFullPlayer.toggle()
                                    }
                            }
                        }
                        TabBarView(viewModel: viewModel)
                    }
                }
            }
            .sheet(isPresented: $showFullPlayer, onDismiss: {
            }, content: {
                FullPlayerView()
            })
            .navigationTitle("Quran Audio".localize)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "circle.grid.cross")
                            .tint(ThemeService.themeColor)
                            .frame(width: 44, height: 44)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: DownloadQueueView()) {
                        Image(systemName: "icloud.and.arrow.down")
                            .tint(ThemeService.themeColor)
                            .frame(width: 44, height: 44)
                    }
                }
                
            }
            
        }
        .deviceNavigationViewStyle()
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
                    Text("Empty Download List".localize)
                }else if viewModel.listType == .favourites {
                    Text("Empty Favourites List".localize)
                }
                Spacer()
            }
            Spacer()
        }
    }
    
    @ViewBuilder private var chapterListView: some View {
        let navigation = NavigationLink(destination: FullPlayerView(),
                                        tag: 10,
                                        selection: $navigateChapterSelection) { Color.clear }
        VStack(spacing:1) {
            if TargetDevice.currentDevice == .nativeMac {
                navigation.frame(height: 0)
            }
            List {
                ForEach(viewModel.chapters, id: \.index) { chapter in
                    ChapterCell(chapter: chapter)
                        .contentShape(Rectangle())
                        .swipeActions(edge: .trailing,
                                      allowsFullSwipe: false,
                                      content: {
                            Button {
                                onFavourite(chapter: chapter)
                            } label: {
                                Image(systemName: viewModel.favouriteImage(chapter: chapter))
                            }.tint(ThemeService.yellow)
                            
                            Button {
                                onDownload(chapter: chapter)
                            } label: {
                                Image(systemName:viewModel.downloadImage(chapter: chapter))
                            }.tint(ThemeService.green)
                        })
                        .onTapGesture {
                            self.viewModel.setCurrent(chapter: chapter)
                            if TargetDevice.currentDevice == .nativeMac {
                                self.navigateChapterSelection = 10
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(.init(top: 0,
                                             leading: 0,
                                             bottom: 1,
                                             trailing: 0))
                }
            }
            .background(.clear)
            .listStyle(.grouped)
        }
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
                        Text("Home".localize)
                            .font(.system(size: 15))
                    }.foregroundColor(viewModel.listType == .all ? ThemeService.themeColor : Color(uiColor: .secondaryLabel))
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
                        Text("Downloads".localize)
                            .font(.system(size: 15))
                    }.foregroundColor(viewModel.listType == .downloads ? ThemeService.themeColor : Color(uiColor: .secondaryLabel))
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
                        Text("Favourites".localize)
                            .font(.system(size: 13))
                    }.foregroundColor(viewModel.listType == .favourites ? ThemeService.themeColor : Color(uiColor: .secondaryLabel))
                }.onTapGesture {
                    if viewModel.listType != .favourites {
                        viewModel.listType = .favourites
                    }
                }
            }
            .foregroundColor(Color(uiColor: .systemBackground))
            .frame(height: 60)
            .background(Color(uiColor: .systemBackground)
                            .ignoresSafeArea(edges:.bottom))
        }
    }
    
    
}

//MARK: Toast Action
extension ChapterListView {
    func onFavourite(chapter:ChapterModel) {
        if viewModel.isFavourite(chapter: chapter) {
            toastType = .info
            toastTitle = "Removed from favourites".localize
            toastDescriptiom = ""
        }else {
            toastType = .info
            toastTitle = "Added to favourites".localize
            toastDescriptiom = ""
        }
        self.showToast = true
        viewModel.onFavouriteChapter(chapterIndex: chapter.index)
    }
    
    func onDownload(chapter:ChapterModel) {
        if viewModel.isDownloaded(chapter: chapter) {
            toastType = .alert
            toastTitle = "Warning".localize
            toastDescriptiom = "Permanently delete the file?".localize
            self.showToast = true
            onToastConfirm = {
                viewModel.deleteChapter(chapter: chapter)
                self.showToast = false
            }
        }else {
            if viewModel.isDownloadQueueEmpty(),
               viewModel.isDownloadWithWifiOnly() {
                toastType = .alert
                toastTitle = "Warning".localize
                toastDescriptiom = "Start Download using Cellular?".localize
                onToastConfirm = {
                    viewModel.setDownloadWithCellularAndWifi()
                    self.showToast = false
                }
            }else if viewModel.isInDownloadQueue(chapter: chapter){
                toastType = .info
                toastTitle = "Removed from download queue.".localize
                toastDescriptiom = ""
            }else {
                toastType = .info
                toastTitle = "Added to download queue.".localize
                toastDescriptiom = ""
            }
            
            viewModel.addToDownloadQueue(chapter: chapter)
            self.showToast = true
        }
    }
}


struct ChapterListView_Previews: PreviewProvider {
    static var previews: some View {
        ChapterListView()
        ChapterListView()
            .preferredColorScheme(.dark)
    }
}
        
