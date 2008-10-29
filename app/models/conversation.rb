class Conversation < ActiveRecord::Base
  
  validates_presence_of :name
  validates_presence_of :description

  # do not validate the uniquness of the personal conversations names, they will be guaranteed to be unique since the user names will be
  validates_uniqueness_of   :name,                       :if => :is_non_personal_conversation?
  validates_length_of       :name,    :within => 8..100, :if => :is_non_personal_conversation?
  
  validates_length_of       :description, :within => 0..10000
  
  has_many :messages

  def is_non_personal_conversation?
    personal_conversation.blank? || personal_conversation == 0
  end

  #virtual attribute requires only to make it possible to pass the user (current_user) who creted the conversation to after_create from controller
  attr_accessor :created_by

  def users_in_conversation
    User.find(:all, :include => :messages, :conditions => {"messages.conversation_id" => id})
  end
  
  def after_create 
    @message = Message.new
    @message.user = self.created_by
    @message.conversation = self
    @message.message = "Welcome to " + self.name
    @message.save
  end


end
  