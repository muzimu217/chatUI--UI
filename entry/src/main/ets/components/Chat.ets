import { ChatMessage } from './ChatMessage'
import { ChatDataSource, IChatDataSource } from './ChatDataSource'
import inputMethod from '@ohos.inputMethod';
import { ChatConfig, ChatRole } from '../common/ChatConfig'
import { WelcomeCard } from './WelcomeCard'
import { OptionCard } from './OptionCard'
import { MorePanels } from './MorePanels'
import font from '@ohos.font';
import router from '@ohos.router';
import { lvMarkdownIn } from '@luvi/lv-markdown-in'

interface IChatComponent {
  userInput: string

  //发送消息到UI
  //clearInput：指示是否清空输入框
  postMessage(msg: ChatMessage, clearInput?: boolean): void

  setTyping(isTyping: boolean): void

  submitUserInput(userInputText: string): void
}

class ChatController {
  chatCtrl: IChatComponent | undefined = undefined

  submitUserInput(userInputText: string) {
    if (this.chatCtrl) {
      this.chatCtrl.submitUserInput(userInputText)
    }

  }
}


@Entry
@Component
struct Chat {
  @State messages: IChatDataSource = new ChatDataSource();
  @State userInput: string = ''
  @State isResponding: boolean = false
  @State clearBtnOffset: number = 10
  private listScroller: Scroller = new Scroller();
  public onClear?: (event?: ClickEvent) => void;
  public onSendMessage?: (ctl: IChatComponent, message: ChatMessage) => void;
  public botAvatar: Resource = $r('app.media.chatbot')
  public userAvatar: Resource = $r('app.media.me')
  public backIcon: Resource = $r('app.media.back')
  public clearChatIcon: Resource = $r('app.media.clear')
  public AddButtonIcon: Resource = $r('app.media.add')
  public MoreModelIcon: Resource = $r('app.media.more')
  public photoIcon: Resource = $r('app.media.icon_photo')
  public shootIcon: Resource = $r("app.media.icon_scan")
  public voiceIcon: Resource = $r('app.media.icon_voice')
  public cameraIcon: Resource = $r('app.media.icon_camera')
  public voice2Icon: Resource = $r('app.media.icon_voice2')
  public keyboardIcon: Resource = $r("app.media.icon_keyboard")
  @State showSubmitButton: boolean = false
  @State title: string = "ChatBot"
  @State needTitleBar: boolean = true
  public needClearChatButton: boolean = true
  public needVoiceButtonControl: boolean = true
  @State needVoiceButton:  boolean = false
  public welcomeCard: boolean = true
  public welcomeMessage: string = "主人好，我是智能助理，你的贴心小助手~"
  public photoIcontext:  string = "图片"
  public shootIcontext:  string = "拍摄"
  public voiceIcontext:  string = "语音输入"
  //自定义消息颜色
  public botMessageBackgroundColor: ResourceColor = '#ffffffff'
  public botMessageTextColor: ResourceColor = Color.Black
  public userMessageBackgroundColor: ResourceColor = '#96ed6a'
  public userMessageTextColor: ResourceColor = Color.Black
  public messageFontSize: number = 18
  public needSubmitButton: boolean = true
  public needAddButton: boolean = true
  public submitButtonIcon: Resource = $r('app.media.send_plane')
  public inputTextPlaceHolder: string = "Let's talk"
  public inputTextPlaceHolderColor: ResourceColor = "#999"
  public inputTextColor: ResourceColor = Color.Black
  @State needInputControl: boolean = true
  @State needBackButton: boolean = true
  public MoreModelButton: boolean = true
  public needVoice2Button: boolean = false
  @State isPanelShow: boolean = false
  @State panelTranslateY: number = 100
  @State panelOpacity: number = 0
  // @State translateY: number = 0 // 控制整体 Y 轴偏移
  public controller?: ChatController
  public useMarkdown: boolean = false
  public needOptionCardShow: boolean = true
  @State needOptionCard: boolean = true
  public choiceTitleText: string = '您可以试着问我:';
  public choiceMassage1: string = '选项A';
  public choiceMassage2: string = '选项B';
  public choiceMassage3: string = '选项C';
  public choiceborderRadius: number = 5;
  @State choiceText: string = '';

  private animateRemoveCard() {
    animateTo({
      duration: 300,
      curve: Curve.EaseOut // 动画结束时减速，适合退出效果
    }, () => {
      this.needOptionCard = false; // 隐藏卡片组件
    });
  }


  submitUserInput(userInputText: string) {
    this.userInput = userInputText
    if (this.userInput && !this.isResponding) {
      if (this.onSendMessage) {
        this.isResponding = true
        this.onSendMessage(this, new ChatMessage({
          role: ChatRole.User,
          content: this.userInput
        }))
      }
    }
  }



  @BuilderParam InputControl: () => void = this.defaultInputText

  @Builder
  defaultInputText() {
    Stack() {
       Column() {
         if (this.needVoiceButton){
           Button("按住说话",{
             type: ButtonType.Normal,
           }).backgroundColor("#ffffffff")
             .width("90%")
             .margin({left: 0, right:40})
             .borderRadius(2)
             .fontColor("#ff1f1d1d")
         } else {
           TextInput({
             placeholder: this.inputTextPlaceHolder,
             text: this.userInput
           })
             .fontColor(this.inputTextColor)
             .placeholderColor(this.inputTextPlaceHolderColor)
             .layoutWeight(1)
             .onChange((value: string) => {
               console.info(value);
               this.userInput = value;
               // 判断输入是否为空
               animateTo({
                 duration: 300,
                 curve: Curve.Linear
               }, () => {
                 if (value.trim().length > 0) {
                   this.showSubmitButton = true;
                 } else {
                   this.showSubmitButton = false;
                 }
               })

             })
             .onSubmit((EnterKeyType) => {
               this.submitUserInput(this.userInput)
             })
         }


         Column() {
           if (this.showSubmitButton) {
             Button() {
               Image(this.submitButtonIcon).fillColor("#e150b5f8").width(24).height(24)
             }
             .type(ButtonType.Circle)
             .backgroundColor("#0fff")
             .width(60)
             .height(39)
             .position({ bottom: 0, right: 0 })
             .onClick(() => {
               this.hideKeyboard()
               this.submitUserInput(this.userInput)
             })
           } else  {
             if ( this.needVoiceButtonControl) {
               Button() {
                 Image(this.needVoiceButton ? this.keyboardIcon : this.voice2Icon  ).width(28).height(28)
               }
               .type(ButtonType.Circle)
               .backgroundColor('#0fff')
               .width(60)
               .height(39)
               .position({ bottom: 0, right: 0 })
               .onClick(() => {
                 animateTo({
                   duration: 300,
                   curve: Curve.FastOutSlowIn
                 }, () => {
                   this.needVoiceButton  = !this.needVoiceButton;
                 })
                 console.log("语音键盘切换按钮被点击")
               })
             }
           }

         }
         .width(80)
         .height(50)
         .position({ bottom: 0, right: 0 })

       }
       .width('100%')
       .backgroundColor('#0fff')
       // .translate({ y: this.translateY }) // 整体上移
       .animation({
         duration: 300,
         curve: Curve.EaseInOut
       })
    }
  }

  public setDefaultMessage(role: ChatRole, content: string) {
    if (content) {
      let systemMsg = new ChatMessage({
        role: role,
        content: content
      })
      this.messages.clearData();
      this.messages.pushData(systemMsg);
    } else {
      this.messages.clearData();
    }
  }

  //API 9接口，需要系统应用权限
  //API 10使用hideTextInput
  hideKeyboard() {
    let inputMethodController = inputMethod.getController();
    //inputMethodController.hideSoftKeyboard()
    inputMethodController.hideTextInput();
  }

  //@State isTyping: boolean = false;

  setTyping(isTyping: boolean = false) {
    if (isTyping) {
      this.messages.pushData(new ChatMessage({
        role: ChatRole.Assistant,
        content: ""
      }))
      this.listScroller.scrollToIndex(this.messages.totalCount() - 1)
    } else {
      let lastMsg: ChatMessage = this.messages.getData(this.messages.totalCount() - 1)
      if (!lastMsg.content) {
        this.messages.removeData(this.messages.totalCount() - 1)
      }
    }
    this.isResponding = isTyping
  }

  postMessage(msg: ChatMessage, clearInput: boolean = true) {
    let lastMsg: ChatMessage = this.messages.getData(this.messages.totalCount() - 1)
    if (!lastMsg.content) {
      this.messages.updateData(this.messages.totalCount() - 1, msg)
    } else {
      this.messages.pushData(msg)
    }
    if (clearInput) {
      this.userInput = ''
    }
    this.listScroller.scrollToIndex(this.messages.totalCount() - 1)
    this.isResponding = false
  }

  aboutToAppear() {
    if (this.controller) {
      this.controller.chatCtrl = this
    }

    this.submitUserInput.bind(this)
    this.postMessage.bind(this)
    this.setTyping.bind(this)
    if (this.welcomeMessage) {
      this.setDefaultMessage(ChatRole.Assistant, this.welcomeMessage)
    }
    if (this.MoreModelButton){
      this.clearBtnOffset = 50
    }
  }

  build() {
    Stack(){
      Column() {
        if (this.needTitleBar) {
          RelativeContainer() {
            Text(this.title)
              .fontWeight(FontWeight.Bold)
              .fontSize(20)
              .id('titleBar')
              .alignRules({
                center: { anchor: '__container__', align: VerticalAlign.Center },
                middle: { anchor: '__container__', align: HorizontalAlign.Center }
              })

            Row() {
              if (this.needBackButton) {
                Button() {
                  Row() {
                    Image(this.backIcon).width(30).height(30)
                    Text("返回").fontSize(20)
                  }
                }
                .alignRules({
                  center: { anchor: '__container__', align: VerticalAlign.Center },
                  left: { anchor: '__container__', align: HorizontalAlign.Start }
                })
                .margin({ left: 10 })
                .id('backBtn')
                .onClick(() => {
                  console.log("返回按钮被点击")
                  router.back()
                })
                .backgroundColor('#0fff')
              }
              // Button() {
              //   Image(this.MoreModelIcon).width(30).height(30)
              // }
              // .alignRules({
              //   center: { anchor: '__container__', align: VerticalAlign.Center },
              //   left: { anchor: '__container__', align: HorizontalAlign.Start }
              // })
              // .margin({ left: 10 })
              // .id('more2Btn')
              // .onClick(() => {
              //   //添加按钮点击逻辑
              // })
              // .backgroundColor('#0fff')
            }
            .alignRules({
              center: { anchor: '__container__', align: VerticalAlign.Center },
              left: { anchor: '__container__', align: HorizontalAlign.Start }
            })

            Row() {
              if (this.needClearChatButton) {
                Button() {
                  Image(this.clearChatIcon)
                    .width(30)
                    .height(30)
                }
                .alignRules({
                  center: { anchor: '__container__', align: VerticalAlign.Center },
                  right: { anchor: '__container__', align: HorizontalAlign.End }
                })
                .margin({ right: 10 }) //this.clearBtnOffset
                .id('clearBtn')
                .onClick((evt) => {
                  console.log("清除聊天按钮被点击")
                  if (this.onClear) {
                    this.onClear(evt);
                  }
                  this.setDefaultMessage(ChatRole.Assistant, this.welcomeMessage)
                })
                .backgroundColor('#0fff')
              }
              if (this.MoreModelButton) {
                Button() {
                  Image(this.MoreModelIcon)
                    .width(30)
                    .height(30)
                }
                .alignRules({
                  center: { anchor: '__container__', align: VerticalAlign.Center },
                  right: { anchor: '__container__', align: HorizontalAlign.End }
                })
                .margin({ right: 10 })
                .id('moreBtn')
                .onClick(() => {
                  console.log("更多按钮被点击")
                  //添加按钮点击逻辑
                })
                .backgroundColor('#0fff')

              }
            }
            .alignRules({
              center: { anchor: '__container__', align: VerticalAlign.Center },
              right: { anchor: '__container__', align: HorizontalAlign.End }
            })
          }
          .height(60)
          .border({ width: { top: 0, bottom: 1 }, color: '#999' })
          .width('100%')

        }

        List({ scroller: this.listScroller }) {
          if (this.welcomeCard) {
            WelcomeCard({ welcomeMessage: this.welcomeMessage })
          }
          if (this.needOptionCard && this.needOptionCardShow) {
            OptionCard({
              choiceTitleText: this.choiceTitleText,
              choiceMassage1: this.choiceMassage1,
              choiceMassage2: this.choiceMassage2,
              choiceMassage3: this.choiceMassage3,
              choiceborderRadius: this.choiceborderRadius,
              onOptionClick: (selectedOption: string) => {
                // 在这里可以处理选中内容，比如设置到输入框或直接提交
                console.log("Selected option:", selectedOption)
                this.choiceText = selectedOption;
                this.animateRemoveCard()
              }
            })
          }
          LazyForEach(this.messages, (item: ChatMessage) => {
            ListItem() {

              if (item.role == ChatRole.User.toString()) {
                Row() {
                  Blank()
                    .width(55)
                  Column() {
                    if (item.picurl) {
                      Image(item.picurl)

                    } else {
                      if (this.useMarkdown) {
                        // lvMarkdownIn({
                        //   text: item.content,
                        //   textStyle: {
                        //     textSize: this.messageFontSize,
                        //     textColor: this.userMessageTextColor as string,
                        //     textMarkBackground: '#00000000'
                        //   }
                        // })

                      } else {
                        Text(item.content)
                          .fontSize(this.messageFontSize)
                          .textAlign(TextAlign.Start)
                          .width('100%')
                          .fontColor(this.userMessageTextColor)
                      }
                    }
                  }
                  .backgroundColor(this.userMessageBackgroundColor)
                  .layoutWeight(1)
                  //.height(80)
                  .padding(15)
                  .margin({ right: 15 })
                  // .borderRadius(5)

                  Button() {
                    Image(this.userAvatar)
                      .width(40)
                      .height(40)
                  }
                  .type(ButtonType.Circle)
                  .backgroundColor('#eee')
                  .width(40)
                  .height(40)
                }
                .justifyContent(FlexAlign.End)
                .padding(10)
                .alignItems(VerticalAlign.Top)
                .width('100%')
              } else {
                Row() {
                  Button() {
                    Image(this.botAvatar)
                      .width(40)
                      .height(40)
                  }
                  .type(ButtonType.Circle)
                  .width(40)
                  .height(40)
                  .backgroundColor(Color.Transparent)

                  Column() {
                    if (this.isResponding && !item.content?.length) {
                      LoadingProgress()
                        .color(this.botMessageTextColor)
                        .width(40)
                        .height(40)
                    } else {
                      if (item.picurl) {
                        Image(item.picurl)

                      } else {
                        if (this.useMarkdown) {
                          // lvMarkdownIn({
                          //   text: item.content,
                          //   textStyle: {
                          //     textSize: this.messageFontSize,
                          //     textColor: this.userMessageTextColor as string,
                          //     textMarkBackground: '#00000000'
                          //   }
                          // })
                        } else {
                          Text(item.content)
                            .fontSize(this.messageFontSize)
                            .textAlign(TextAlign.Start)
                            .width('100%')
                            .fontColor(this.botMessageTextColor)
                        }
                      }
                    }
                  }
                  .alignItems(HorizontalAlign.Start)
                  .backgroundColor(this.botMessageBackgroundColor)
                  .layoutWeight(1)
                  //.height(80)
                  .padding(15)
                  .margin({ left: 15 })
                  // .borderRadius(5)

                  Blank()
                    .width(55)
                }
                .alignItems(VerticalAlign.Top)
                .padding(10)
                .width('100%')
              }


            }

          })

        }
        .layoutWeight(1)
        .cachedCount(3)
        .scrollBar(BarState.Auto)
        .onClick(() => {
          animateTo({
            duration: 400,
            curve: Curve.EaseInOut
          }, () => {
            this.isPanelShow = false
          })
          console.log("Add button clicked")
        })

        if (this.needInputControl) {
          Stack() {
            // 模糊背景层
            Flex()
              .width('100%')
              .height(60)
              .borderRadius(10)
              .backgroundColor('rgba(255, 255, 255, 0.4)') // 半透明白色背景
              .blur(10)
              .border({ width: { bottom: 2, top: 2, left: 2, right: 2  }, color: '#e0e0e0' }) // 可选：增加底部边框提升层次感

            Flex() {
              if (this.needVoice2Button) {
                Button() {
                  Image(this.voice2Icon)
                    .width(28)
                    .height(28)
                }
                .backgroundColor('#00fcfcfc')
                .width(60)
                .height(39)
                .alignRules({
                  center: { anchor: '__container__', align: VerticalAlign.Center },
                  left: { anchor: '__container__', align: HorizontalAlign.Start }
                })
                .onClick(() => {
                  console.log("语音按钮被点击")
                  // 添加点击逻辑
                })
              }

              this.InputControl()

              if (this.needAddButton) {
                Button() {
                  Image(this.AddButtonIcon).width(28).height(28)
                }
                .type(ButtonType.Circle)
                .backgroundColor('#0fff')
                .margin({ top: 4 })
                .width(60)
                .height(39)
                .alignRules({
                  center: { anchor: '__container__', align: VerticalAlign.Center },
                  right: { anchor: '__container__', align: HorizontalAlign.End }
                })
                .onClick(() => {
                  console.log("添加按钮被点击")
                  animateTo({
                    duration: 400,
                    curve: Curve.EaseInOut
                  }, () => {
                    this.isPanelShow = !this.isPanelShow
                  })
                })
              }
            }
            .padding(10)
            .width('100%')
            .height(60)
          }
          .width('95%')
          .height(60)
        }



        if (this.isPanelShow) {
          MorePanels({
            shootIcontext: this.shootIcontext,
            voiceIcontext: this.voiceIcontext,
            photoIcontext: this.photoIcontext,
            panelOpacity: this.panelOpacity,
            panelTranslateY: this.panelTranslateY
          })
          // Stack() {
          //   Row() {
          //     Column({ space: 5 }) {
          //       Button() {
          //         Column() {
          //           Image($r('app.media.icon_photo')).width(40).height(40)
          //           Text(this.photoIcontext).fontSize(14).fontColor('#333')
          //         }
          //       }.backgroundColor('#fff').type(ButtonType.Normal).size({ width: 80, height: 80 }).borderRadius(10)
          //     }
          //     .alignItems(HorizontalAlign.Center)
          //
          //     Column({ space: 5 }) {
          //       Button() {
          //         Column() {
          //           Image($r('app.media.icon_camera')).width(40).height(40)
          //           Text(this.shootIcontext).fontSize(14).fontColor('#333')
          //         }
          //       }.backgroundColor('#fff').type(ButtonType.Normal).size({ width: 80, height: 80 }).borderRadius(10)
          //     }
          //     .alignItems(HorizontalAlign.Center)
          //
          //     Column({ space: 5 }) {
          //       Button() {
          //         Column() {
          //           Image($r('app.media.icon_voice')).width(40).height(40)
          //           Text(this.voiceIcontext).fontSize(14).fontColor('#333')
          //         }
          //       }.backgroundColor('#fff').type(ButtonType.Normal).size({ width: 80, height: 80 }).borderRadius(10)
          //
          //     }
          //     .alignItems(HorizontalAlign.Center)
          //   }
          //   .width('100%')
          //   .justifyContent(FlexAlign.SpaceAround)
          //   .backgroundColor('#fff')
          //   .transition({
          //     type: TransitionType.All,
          //     opacity: this.panelOpacity,
          //     translate: { y: this.panelTranslateY },
          //     scale: { x: 1, y: 1 }
          //   })
          // }
        }
      }
      .backgroundColor('#80dbd9d9')
      .height('100%')
      .width('100%')
    }
  }

  aboutToDisappear() {
    if (this.controller) {
      this.controller = undefined
    }

  }
}

export { Chat, IChatComponent, ChatController }