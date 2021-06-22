'keystore' - a Java keystore with an SSL certificate
'password' - the keystore's password
'maxTextLength' - maximum text length, longer texts will cause an error (optional)
'maxTextHardLength' - maximum text length, applies even to users with a special secret 'token' parameter (optional)
'secretTokenKey' - secret JWT token key, if set by user and valid, maxTextLength can be increased by the user (optional)
'maxCheckTimeMillis' - maximum time in milliseconds allowed per check (optional)
'maxErrorsPerWordRate' - checking will stop with error if there are more rules matches per word (optional)
'maxSpellingSuggestions' - only this many spelling errors will have suggestions for performance reasons (optional,                           affects Hunspell-based languages only)
'maxCheckThreads' - maximum number of threads working in parallel (optional)
'cacheSize' - size of internal cache in number of sentences (optional, default: 0)
'cacheTTLSeconds' - how many seconds sentences are kept in cache (optional, default: 300 if 'cacheSize' is set)
'requestLimit' - maximum number of requests per requestLimitPeriodInSeconds (optional)
'requestLimitInBytes' - maximum aggregated size of requests per requestLimitPeriodInSeconds (optional)
'timeoutRequestLimit' - maximum number of timeout request (optional)
'requestLimitPeriodInSeconds' - time period to which requestLimit and timeoutRequestLimit applies (optional)
'languageModel' - a directory with '1grams', '2grams', '3grams' sub directories which contain a Lucene index  each with ngram occurrence counts; activates the confusion rule if supported (optional)
'word2vecModel' - a directory with word2vec data (optional), see  https://github.com/languagetool-org/languagetool/blob/master/languagetool-standalone/CHANGES.md#word2vec
fasttextModel=
fasttextBinary=
'maxWorkQueueSize' - reject request if request queue gets larger than this (optional)
'rulesFile' - a file containing rules configuration, such as .langugagetool.cfg (optional)
'warmUp' - set to 'true' to warm up server at start, i.e. run a short check with all languages (optional)
'blockedReferrers' - a comma-separated list of HTTP referrers (and 'Origin' headers) that are blocked and will not be served (optional)
'disabledRuleIds' - a comma-separated list of rule ids that are turned off for this server (optional)



Spellcheck-only languages: You can add simple spellcheck-only support for languages that LT doesn't
support by defining two optional properties:
  'lang-xx' - set name of the language, use language code instead of 'xx', e.g. lang-tr=Turkish
  'lang-xx-dictPath' - absolute path to the hunspell .dic file, use language code instead of 'xx', e.g.
                                        lang-tr-dictPath=/path/to/tr.dic. Note that the same directory also needs to
                                        contain a common_words.txt file with the most common 10,000 words (used for better language detection)