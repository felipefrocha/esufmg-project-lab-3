from tkinter import *
from PIL import ImageTk,Image
import os

# try:
#     import sim
# except:
#     print ('--------------------------------------------------------------')
#     print ('"sim.py" could not be imported. This means very probably that')
#     print ('either "sim.py" or the remoteApi library could not be found.')
#     print ('Make sure both are in the same folder as this file,')
#     print ('or appropriately adjust the file "sim.py"')
#     print ('--------------------------------------------------------------')
#     print ('')
    
# class Client:
#     def __enter__(self):
#         self.intSignalName='legacyRemoteApiStepCounter'
#         self.stepCounter=0
#         self.lastImageAcquisitionTime=-1
#         sim.simxFinish(-1) # just in case, close all opened connections
#         self.id=sim.simxStart('192.168.15.50',19999,True,True,5000,5) # Connect to CoppeliaSim
#         return self
    
#     def __exit__(self,*err):
#         sim.simxFinish(-1)

# with Client() as client:
#     client.runInSynchronousMode=True
    
#     print("running")

#     if client.id!=-1:
#         print ('Connected to remote API server')
#     else:
#         raise Exception("THis was not possible!")


def get_subtitle(root):
    sub_title_page = Label(root, text="Laboratório de projetos III")
    sub_title_page.grid()
    status = Label(root, text='This property can be between: ', bd=1, relief=SUNKEN, anchor=W)
    status.grid(row=5, column=0, columnspan=3, stricky=W+E )





def main():
    root = Tk()
    root.title('Lab Projetos 3 - Controladora teleoperada de Grua')
    root.iconbitmap('./assets/index.ico')
    # All images and dynamic items shoul be here
    UFMG = ImageTk.PhotoImage(Image.open("./assets/index.png"))
    logo_ufmg = Label(root, image=UFMG)
    logo_ufmg.grid(row=0,columnspan=4)
    
    get_subtitle(root)
    
    root.mainloop()



if __name__ == "__main__":
    main()
