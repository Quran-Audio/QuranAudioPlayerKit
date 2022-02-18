//
//  SettingsView.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 28/01/22.
//

import SwiftUI
import MessageUI

struct SettingsView: View {
    @State var result: Result<MFMailComposeResult, Error>? = nil
       @State var isShowingMailView = false
    @ObservedObject var viewModel = SettingsViewModel()
    var body: some View {
        ScrollView {
            VStack(alignment:.leading,spacing: 0) {
                Spacer(minLength: 20)
                if TargetDevice.currentDevice != .nativeMac {
                    downloadWithView
                }
                emailView
                addToDownloadQueueView
                shareView
                Spacer()
            }
        }
        .foregroundColor(Color(uiColor: .label))
        .navigationTitle("Settings".localize)
    }
}

//MARK: Download With
extension SettingsView {
    @ViewBuilder var addToDownloadQueueView:some View {
        VStack(alignment:.leading) {
            HStack{
                Image(systemName:viewModel.downloadWithPlay ? "checkmark.square":"square")
                Text("Add to download queue while playing".localize)
                Spacer()
            }
            .contentShape(Rectangle())
            .padding(.horizontal,10)
            .onTapGesture {
                viewModel.setDownloadWhilePlay()
            }
        }
        .padding(.horizontal, 10)
        .font(.system(size: 20))
    }
        
    @ViewBuilder var shareView:some View {
        VStack(alignment:.leading) {
            Button(action: {
                actionSheet()
            }, label: {
                HStack{
                    Text("Share App".localize).bold()
                    Spacer()
                    Image(systemName: "square.and.arrow.up")
                }
                .foregroundColor(Color(uiColor: .label))
            })
                .padding(.all,10)
        }
        .padding()
        .font(.system(size: 20))
    }
    @ViewBuilder var emailView:some View {
        VStack(alignment:.leading) {
            Button(action: {
                if MFMailComposeViewController.canSendMail() {
                    self.isShowingMailView.toggle()
                }
            }, label: {
                HStack{
                    VStack(alignment: .leading) {
                        Text("Email your suggestions".localize).bold()
                        if !MFMailComposeViewController.canSendMail() {
                            Text("Email not configured!".localize)
                                .font(.system(size: 15))
                                .foregroundColor(ThemeService.themeColor.opacity(0.7))
                        }
                    }
                    Spacer()
                    Image(systemName: "envelope")
                }
                .foregroundColor(Color(uiColor: .label))
            })
                .disabled(!MFMailComposeViewController.canSendMail())
                        .sheet(isPresented: $isShowingMailView) {
                            MailView(result: self.$result)
                        }
                .padding(10)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 40)
        .font(.system(size: 20))
    }
    
    @ViewBuilder var downloadWithView:some View {
        
        VStack(alignment:.leading) {
            Text("Download with:".localize).bold()
            Button(action: {
                viewModel.setDownloadWithWifi()
            }, label: {
                HStack{
                    Image(systemName:viewModel.downloadWith == .wifi ? "checkmark.square":"square")
                    Text("Wifi")
                    Spacer()
                    Image(systemName: "wifi")
                }
                .foregroundColor(Color(uiColor: .label))
            })
                .padding(10)
            
            Button(action: {
                viewModel.setDownloadWithCellularAndWifi()
            }, label: {
                HStack{
                    Image(systemName:viewModel.downloadWith == .cellularAndWifi ? "checkmark.square":"square")
                    Text("Cellular and Wifi".localize)
                    Spacer()
                    Image(systemName: "candybarphone")
                    Image(systemName: "wifi")
                }
                .foregroundColor(Color(uiColor: .label))
            })
                .padding(10)
        }
        .font(.system(size: 20))
        .padding(.horizontal,10)
    }
    
    private func actionSheet() {
        let data = viewModel.shareText
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsView()
            SettingsView()
                .preferredColorScheme(.dark)
        }
    }
}
