//OptionCard.ets
@Component
struct OptionCard {
  public choiceTitleText: string = '';
  public choiceMassage1: string = '';
  public choiceMassage2: string = '';
  public choiceMassage3: string = '';
  public choiceborderRadius: number = 5;
  public  onOptionClick: (option: string) => void = () => {}



  build() {
    Column() {
      Text(this.choiceTitleText)
        .fontSize(15)
        .fontColor("#ff838383")
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .textAlign(TextAlign.Start)
        .margin({ top: 0, left:40 })

      Button(this.choiceMassage1)
        .width('80%')
        .height(20)
        .type(ButtonType.Normal)
        .borderRadius(this.choiceborderRadius)
        .margin({ top: 10 })
        .onClick(() => {
          // 处理点击事件
          this.onOptionClick(this.choiceMassage1)
          console.log("选项A"+"被点击")
        })

      Button(this.choiceMassage2)
        .width('80%')
        .height(20)
        .type(ButtonType.Normal)
        .borderRadius(this.choiceborderRadius)
        .margin({ top: 10 })
        .onClick(() => {
          // 处理点击事件
          this.onOptionClick(this.choiceMassage2)
          console.log("选项B"+"被点击")
        })

      Button(this.choiceMassage3)
        .width('80%')
        .height(20)
        .type(ButtonType.Normal)
        .borderRadius(this.choiceborderRadius)
        .margin({ top: 10 })
        .onClick(() => {
          // 处理点击事件
          this.onOptionClick(this.choiceMassage3)
          console.log("选项C"+"被点击")
        })
    }
    .width('90%')
    .padding({ top: 20, bottom: 20 })
    .backgroundColor('#f5f5f5')
    .borderRadius(10)
    .margin({ top: 10, left: '5%', right: '5%' })
  }
}
export { OptionCard }
