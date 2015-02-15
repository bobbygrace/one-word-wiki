_ = require 'underscore'

validateInput = (input) ->
  # No spaces or punctuation (except hyphens). Output the first word.
  pattern = /[\.,\/#!?@$%\^&\*;:{}=_`~()]/g
  punctuationlessInput = input.replace(pattern," ")
  split = _.compact(punctuationlessInput.trim().split(" "))
  output = split?[0] ? ""
  output = output.trim()

  errorInvalidCharacters = pattern.test(input)
  errorTooManyWords = split.length > 1
  errorEmptyWord = _.isEmpty(output)

  return {input, output, errorInvalidCharacters, errorTooManyWords, errorEmptyWord}

module.exports = validateInput
