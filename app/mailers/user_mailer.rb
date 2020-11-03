class UserMailer < ApplicationMailer
  default from: 'event-ually@yopmail.fr'
 
  def welcome_email(user)
    #on récupère l'instance user pour ensuite pouvoir la passer à la view en @user
    @user = user 

    #on définit une variable @url qu'on utilisera dans la view d’e-mail
    @url  = 'https://event-ually.herokuapp.com/login' 

    # c'est cet appel à mail() qui permet d'envoyer l’e-mail en définissant destinataire et sujet.
    mail(to: @user.email, subject: 'Bienvenue chez nous !') 
  end

  def new_attendance_email(user, event)
    @user = user
    @event = event
    @url = 'https://event-ually.herokuapp.com/event/' + @event.id 
    mail(to: @user.email, subject: '+1 participant pour ton event !')
  end
end
