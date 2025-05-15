// WelcomeCard.ets
@Component
struct WelcomeCard {
  @Prop welcomeMessage: string = "主人好，我是智能助理，你的贴心小助手~"

  build() {
    Column() {
      Text("欢迎来到智能助理")
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .margin({ bottom: 5 })

      Text(this.welcomeMessage)
        .fontSize(16)
        .textAlign(TextAlign.Center)
        .fontColor('#666')
    }
    .width('100%')
    .padding({ top: 15, bottom: 15 })
    .backgroundColor('#f0f8ff') // 浅蓝色背景
    .borderRadius(10)
  }
}
export { WelcomeCard }