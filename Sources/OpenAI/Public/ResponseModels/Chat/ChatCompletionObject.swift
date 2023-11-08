//
//  ChatCompletionObject.swift
//
//
//  Created by James Rochabrun on 10/10/23.
//

import Foundation

/// Represents a chat [completion](https://platform.openai.com/docs/api-reference/chat/object) response returned by model, based on the provided input.
public struct ChatCompletionObject: Decodable {
   
   /// A unique identifier for the chat completion.
   public let id: String
   /// A list of chat completion choices. Can be more than one if n is greater than 1.
   public let choices: [ChatChoice]
   /// The Unix timestamp (in seconds) of when the chat completion was created.
   public let created: Int
   /// The model used for the chat completion.
   public let model: String
   /// This fingerprint represents the backend configuration that the model runs with.
   /// Can be used in conjunction with the seed request parameter to understand when backend changes have been made that might impact determinism.
   public let systemFingerprint: String?
   /// The object type, which is always chat.completion.
   public let object: String
   /// Usage statistics for the completion request.
   public let usage: ChatUsage
   
   public struct ChatChoice: Decodable {
      
      /// The reason the model stopped generating tokens. This will be stop if the model hit a natural stop point or a provided stop sequence, length if the maximum number of tokens specified in the request was reached, content_filter if content was omitted due to a flag from our content filters, tool_calls if the model called a tool, or function_call (deprecated) if the model called a function.
      public let finishReason: IntOrStringValue
      /// The index of the choice in the list of choices.
      public let index: Int
      /// A chat completion message generated by the model.
      public let message: ChatMessage
      
      public struct ChatMessage: Decodable {
         
         /// The contents of the message.
         public let content: String?
         /// The tool calls generated by the model, such as function calls.
         public let toolCalls: [ToolCall]?
         /// The name and arguments of a function that should be called, as generated by the model.
         @available(*, deprecated, message: "Deprecated and replaced by `tool_calls`")
         public let functionCall: FunctionCall?
         /// The role of the author of this message.
         public let role: String
         
         public struct ToolCall: Decodable {
            /// The ID of the tool call.
            public let id: String?
            /// The type of the tool. Currently, only `function` is supported.
            public let type: String?
            /// The function that the model called.
            public let function: FunctionCall
            
            public init(
               id: String,
               type: String = "function",
               function: FunctionCall)
            {
               self.id = id
               self.type = type
               self.function = function
            }
         }
         
         public struct FunctionCall: Decodable {
            /// The name of the function to call.
            public let name: String
            /// The arguments to call the function with, as generated by the model in JSON format. Note that the model does not always generate valid JSON, and may hallucinate parameters not defined by your function schema. Validate the arguments in your code before calling your function.
            public let arguments: String
         }
         
         enum CodingKeys: String, CodingKey {
            case content
            case toolCalls = "tool_calls"
            case functionCall = "function_call"
            case role
         }
      }
      
      enum CodingKeys: String, CodingKey {
         case finishReason = "finish_reason"
         case index
         case message
      }
   }
   
   enum CodingKeys: String, CodingKey {
      case id
      case choices
      case created
      case model
      case systemFingerprint = "system_fingerprint"
      case object
      case usage
   }
   
   public struct ChatUsage: Decodable {
      
      /// Number of tokens in the generated completion.
      public let completionTokens: Int
      /// Number of tokens in the prompt.
      public let promptTokens: Int
      /// Total number of tokens used in the request (prompt + completion).
      public let totalTokens: Int
      
      enum CodingKeys: String, CodingKey {
         case completionTokens = "completion_tokens"
         case promptTokens = "prompt_tokens"
         case totalTokens = "total_tokens"
      }
   }
}
