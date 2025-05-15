//MorePanels.ets
@Component
struct MorePanels {
  public photoIcontext: string = '相册'
  public shootIcontext: string = '拍摄'
  public voiceIcontext: string = '语音'
  public panelOpacity: number = 0
  public panelTranslateY: number = 100



  build() {
    Stack() {
      Row() {
        Column({ space: 5 }) {
          Button() {
            Column() {
              Image($r('app.media.icon_photo')).width(40).height(40)
              Text(this.photoIcontext).fontSize(14).fontColor('#333')
            }
          }.backgroundColor('#0fff').type(ButtonType.Normal).size({ width: 80, height: 80 }).borderRadius(10)
        }
        .alignItems(HorizontalAlign.Center)

        Column({ space: 5 }) {
          Button() {
            Column() {
              Image($r('app.media.icon_camera')).width(40).height(40)
              Text(this.shootIcontext).fontSize(14).fontColor('#333')
            }
          }.backgroundColor('#0fff').type(ButtonType.Normal).size({ width: 80, height: 80 }).borderRadius(10)
        }
        .alignItems(HorizontalAlign.Center)

        Column({ space: 5 }) {
          Button() {
            Column() {
              Image($r('app.media.icon_voice')).width(40).height(40)
              Text(this.voiceIcontext).fontSize(14).fontColor('#333')
            }
          }.backgroundColor('#0fff').type(ButtonType.Normal).size({ width: 80, height: 80 }).borderRadius(10)

        }
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceAround)
      .backgroundColor('#0fff')
      .padding(10)
      .transition({
        type: TransitionType.All,
        opacity: this.panelOpacity,
        translate: { y: this.panelTranslateY },
        scale: { x: 1, y: 1 }
      })
    }
  }
}
export {  MorePanels }