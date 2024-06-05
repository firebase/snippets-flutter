// Copyright 2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// ignore_for_file: avoid_print, unused_local_variable

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:firebase_snippets_app/snippets/snippet_base.dart';

class VertexAISnippets extends DocSnippet {
  late final GenerativeModel model;

  @override
  void runAll() {
    initializeModel();
    configureModel();
    safetySetting();
    multiSafetySetting();
    textGenTextOnlyPromptStream();
    textGenTextOnlyPrompt();
    textGenMultimodalOneImagePromptStream();
    textGenMultimodalOneImagePrompt();
    textGenMultiModalMultiImagePromptStreaming();
    textGenMultiModalMultiImagePrompt();
    textGenMultiModalVideoPromptStreaming();
    textGenMultiModalVideoPrompt();
    countTokensText();
    countTokensTextImage();
    chatStream();
    chat();
    setSystemInstructions();
  }

  void initializeModel() async {
    // [START initialize_model]
    // Initialize FirebaseApp
    await Firebase.initializeApp();
    // Initialize the {{vertexai}} service and the generative model
    // Specify a model that supports your use case
    // Gemini 1.5 models are versatile and can be used with all API capabilities
    final model = FirebaseVertexAI.instance
        .generativeModel(model: 'gemini-1.5-flash');
    // [END initialize_model]
  }

  void configureModel() {
    // [START configure_model]
    // ...

    final generationConfig = GenerationConfig(
      maxOutputTokens: 200,
      stopSequences: ["red"],
      temperature: 0.9,
      topP: 0.1,
      topK: 16,
    );
    final model = FirebaseVertexAI.instance.generativeModel(
      model: 'gemini-1.5-flash',
      generationConfig: generationConfig,
    );

    // ...
    // [END configure_model]
  }

  void safetySetting() {
    // [START safety_setting]
    // ...

    final safetySettings = [
      SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high)
    ];
    final model = FirebaseVertexAI.instance.generativeModel(
      model: 'gemini-1.5-flash',
      safetySettings: safetySettings,
    );

    // ...
    // [END safety_setting]
  }

  void multiSafetySetting() {
    // [START multi_safety_setting]
    // ...

    final safetySettings = [
      SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
      SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
    ];
    final model = FirebaseVertexAI.instance.generativeModel(
      model: 'gemini-1.5-flash',
      safetySettings: safetySettings,
    );

    // ...
    // [END multi_safety_setting]
  }

  void textGenTextOnlyPromptStream() async {
    // [START text_gen_text_only_prompt_streaming]
    // Provide a prompt that contains text
    final prompt = [Content.text('Write a story about a magic backpack.')];

    // To stream generated text output, call generateContentStream with the text input
    final response = model.generateContentStream(prompt);
    await for (final chunk in response) {
      print(chunk.text);
    }
    // [END text_gen_text_only_prompt_streaming]
  }

  void textGenTextOnlyPrompt() async {
    // [START text_gen_text_only_prompt]
    // Provide a prompt that contains text
    final prompt = [Content.text('Write a story about a magic backpack.')];

    // To generate text output, call generateContent with the text input
    final response = await model.generateContent(prompt);
    print(response.text);
    // [END text_gen_text_only_prompt]
  }

  void textGenMultimodalOneImagePromptStream() async {
    // [START text_gen_multimodal_one_image_prompt_streaming]
    // Provide a text prompt to include with the image
    final prompt = TextPart("What's in the picture?");
    // Prepare images for input
    final image = await File('image0.jpg').readAsBytes();
    final imagePart = DataPart('image/jpeg', image);

    // To stream generated text output, call generateContentStream with the text and image
    final response = await model.generateContentStream([
      Content.multi([prompt, imagePart])
    ]);
    await for (final chunk in response) {
      print(chunk.text);
    }
    // [END text_gen_multimodal_one_image_prompt_streaming]
  }

  void textGenMultimodalOneImagePrompt() async {
    // [START text_gen_multimodal_one_image_prompt]
    // Provide a text prompt to include with the image
    final prompt = TextPart("What's in the picture?");
    // Prepare images for input
    final image = await File('image0.jpg').readAsBytes();
    final imagePart = DataPart('image/jpeg', image);

    // To generate text output, call generateContent with the text and image
    final response = await model.generateContent([
      Content.multi([prompt, imagePart])
    ]);
    print(response.text);
    // [END text_gen_multimodal_one_image_prompt]
  }

  void textGenMultiModalMultiImagePromptStreaming() async {
    // [START text_gen_multimodal_multi_image_prompt_streaming]
    final (firstImage, secondImage) = await (
      File('image0.jpg').readAsBytes(),
      File('image1.jpg').readAsBytes()
    ).wait;
    // Provide a text prompt to include with the images
    final prompt = TextPart("What's different between these pictures?");
    // Prepare images for input
    final imageParts = [
      DataPart('image/jpeg', firstImage),
      DataPart('image/jpeg', secondImage),
    ];

    // To stream generated text output, call generateContentStream with the text and images
    final response = model.generateContentStream([
      Content.multi([prompt, ...imageParts])
    ]);
    await for (final chunk in response) {
      print(chunk.text);
    }
    // [END text_gen_multimodal_multi_image_prompt_streaming]
  }

  void textGenMultiModalMultiImagePrompt() async {
    // [START text_gen_multimodal_multi_image_prompt]
    final (firstImage, secondImage) = await (
      File('image0.jpg').readAsBytes(),
      File('image1.jpg').readAsBytes()
    ).wait;
    // Provide a text prompt to include with the images
    final prompt = TextPart("What's different between these pictures?");
    // Prepare images for input
    final imageParts = [
      DataPart('image/jpeg', firstImage),
      DataPart('image/jpeg', secondImage),
    ];

    // To generate text output, call generateContent with the text and images
    final response = await model.generateContent([
      Content.multi([prompt, ...imageParts])
    ]);
    print(response.text);
    // [END text_gen_multimodal_multi_image_prompt]
  }

  void textGenMultiModalVideoPromptStreaming() async {
    // [START text_gen_multimodal_video_prompt_streaming]
    // Provide a text prompt to include with the video
    final prompt = TextPart("What's in the video?");

    // Prepare video for input
    final video = await File('video0.mp4').readAsBytes();

    // Provide the video as `Data` with the appropriate mimetype
    final videoPart = DataPart('video/mp4', video);

    // To stream generated text output, call generateContentStream with the text and image
    final response = model.generateContentStream([
      Content.multi([prompt, videoPart])
    ]);
    await for (final chunk in response) {
      print(chunk.text);
    }
    // [END text_gen_multimodal_video_prompt_streaming]
  }

  void textGenMultiModalVideoPrompt() async {
    // [START text_gen_multimodal_video_prompt]
    // Provide a text prompt to include with the video
    final prompt = TextPart("What's in the video?");

    // Prepare video for input
    final video = await File('video0.mp4').readAsBytes();

    // Provide the video as `Data` with the appropriate mimetype
    final videoPart = DataPart('video/mp4', video);

    // To generate text output, call generateContent with the text and images
    final response = await model.generateContent([
      Content.multi([prompt, videoPart])
    ]);
    print(response.text);
    // [END text_gen_multimodal_video_prompt]
  }

  void countTokensText() async {
    // [START count_tokens_text]
    // Provide a prompt that contains text
    final prompt = [Content.text('Write a story about a magic backpack.')];

    // Count tokens and billable characters before calling generateContent
    final tokenCount = await model.countTokens(prompt);
    print('Token count: ${tokenCount.totalTokens}');
    print('Billable characters: ${tokenCount.totalBillableCharacters}');

    // To generate text output, call generateContent with the text input
    final response = await model.generateContent(prompt);
    print(response.text);
    // [END count_tokens_text]
  }

  void countTokensTextImage() async {
    // [START count_tokens_text_image]
    // Provide a text prompt to include with the image
    final prompt = TextPart("What's in the picture?");
    // Prepare image for input
    final image = await File('image0.jpg').readAsBytes();
    final imagePart = DataPart('image/jpeg', image);

    // Count tokens and billable characters before calling generateContent
    final tokenCount = await model.countTokens([
      Content.multi([prompt, imagePart])
    ]);
    print('Token count: ${tokenCount.totalTokens}');
    print('Billable characters: ${tokenCount.totalBillableCharacters}');

    // To generate text output, call generateContent with the text and image
    final response = await model.generateContent([
      Content.multi([prompt, imagePart])
    ]);
    print(response.text);
    // [END count_tokens_text_image]
  }

  void chatStream() async {
    // [START chat_streaming]
    final chat = model.startChat();
    // Provide a prompt that contains text
    final prompt = Content.text('Write a story about a magic backpack.');

    final response = chat.sendMessageStream(prompt);
    await for (final chunk in response) {
      print(chunk.text);
    }
    // [END chat_streaming]
  }

  void chat() async {
    // [START chat]
    final chat = model.startChat();
    // Provide a prompt that contains text
    final prompt = Content.text('Write a story about a magic backpack.');

    final response = await chat.sendMessage(prompt);
    print(response.text);
    // [END chat]
  }

  void setSystemInstructions() async {
    // [START system_instructions_text]
    await Firebase.initializeApp();
    // Initialize the Vertex AI service and the generative model
    // Specify a model that supports system instructions, like a Gemini 1.5 model
    final model = FirebaseVertexAI.instance.generativeModel(
      model: 'gemini-1.5-flash-preview-0514',
      systemInstruction: Content.system('You are a cat. Your name is Neko.'),
    );
    // [END system_instructions_text]
  }
}
