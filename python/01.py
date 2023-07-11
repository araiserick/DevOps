import random
guess = 0
print('как тебя зовут?')
myName = input('')
number = random.randint(0,100)
print(myName + ',нужно угадать число')

for guess in range(5):

    print('ну что же, myName, поехали')
    print('угадай число')
    Answer = input('')
    Answer = int(Answer)

    if Answer > number:
        print('число меньше')
    if  Answer < number:
        print('чило больше')
    if Answer == number:
        print('угадал')
    break


guess = str(guess+ 1)
print('Отлично, ' + myName + '! Ты справился за ' + guess + ' попытки!')

if guess != number:
    number = str(number)

print('Увы. Я загадала число ' + number + '.')