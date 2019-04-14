
#required gems needed to run the program
require 'rubygems' # not necessary with ruby 1.9 but included for completeness
require 'twilio-ruby'
require 'sinatra'
require 'pry'


todo_array = [] # array of stored todo items

post '/sms' do  #once a message comes in and is posted to the incomming webhook it will trigger a dynamic message response

  body = params['Body'] # make the incoming message body a local variable
  body_array = body.split(' ')  #turn the message body into an array

    #send the array of stored todo items
  if body == 'list' || body == "list " || body == 'List' || body == "List "
    response = Twilio::TwiML::MessagingResponse.new.message body: todo_array
    response.to_s

    #remove the selected todo item from the array and send the updated todo array
  elsif body_array[0] == 'remove' || body_array[0] == 'Remove' || body_array[0] == 'remove ' || body_array[0] == 'Remove '
    index = body_array[1].to_i - 1 #to correct the index startin posistion of 0

    todo_array.delete_at(index) # remove the todo item
    response = Twilio::TwiML::MessagingResponse.new.message body: todo_array
    response.to_s

    #add new todo items with add followed by the todo item
  elsif body_array[0] == 'add' || body_array[0] == 'Add' || body_array[0] == 'add ' || body_array[0] == 'Add '
    to_do_array = body_array[1..body_array.length] #collect all the array elements after the add command
    to_do_string = to_do_array.join(" ") #join all the array elements to a string
    todo_array.push(to_do_string) #add the string to to the end of the todo list

    response = Twilio::TwiML::MessagingResponse.new.message body: todo_array
    response.to_s

    #if anything else is sent, this is returned
  else
    response = Twilio::TwiML::MessagingResponse.new.message body: "I accept the following commands:
                                                                    - list : shows the current tasks
                                                                    - remove #: remove followed by the number to delete
                                                                    - add _____: add followed by the thing you need todo ex. add get milk at store"
    response.to_s
  end
end
