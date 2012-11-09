# ColorizeWords

An example how to use `NSLingusticTagger` to add syntax highlighting to natural language English text. Currently it highlights nouns, personal names and organization names in a body of text but you can easily hack it to tag other parts of speech. 


## Usage

Run the app and then a text document is displayed. By default the app pre-loads Martin Luther King Jr's "I Have a Dream" speech. You can replace the contents by pasting plain text or typing it directly in the editor window; however file load/save functions are not implemented as these are not relevant to the example.


Click on _Process_ to invoke `NSLinguisticTagger` and then the document will be replaced with a read-only view that contains the syntax-highlighted document. This is a WebView and you can copy the text within and paste it to other application while retaining its formatting. To return to the editable view, just click on _Process_ again.


## Hacking

You'll want to look at `TextDocument.m` where most of the action takes place. To change what language parts are tagged, you'll want to modify the `renderText` method. There's a rather complete set of `if` statements commented out that encompasses a most of what `NSLinguisticTagger` is able to recognize out of English text. Just un-comment the tags that you want and then re-run the app. I've left most of them commented out since the output looks too distracting when all of those tags are colorized. 


## License

Please see `LICENSE.txt` for the license. If you're doing anything interesting with this project, let me know at adib@cutecoder.org.



