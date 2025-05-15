export enum ChatRole {
  Assistant = "assistant",
  User = "user"
}

export class ChatConfig {
  private static _instance: ChatConfig

  public  static getInstance() {
    if (!ChatConfig._instance) {
      ChatConfig._instance = new ChatConfig()
    }
    return ChatConfig._instance
  }
}