import math
from tkinter import *
from tkinter import messagebox

from PIL import ImageTk, Image

ASSETS_PATH = "./assets"
UFMG_IMG_PATH = ASSETS_PATH + "/index.png"

teste = 0

try:
    import sim
except:
    print('--------------------------------------------------------------')
    print('"sim.py" could not be imported. This means very probably that')
    print('either "sim.py" or the remoteApi library could not be found.')
    print('Make sure both are in the same folder as this file,')
    print('or appropriately adjust the file "sim.py"')
    print('--------------------------------------------------------------')
    print('')


class Client:
    def __enter__(self):
        self.intSignalName = 'legacyRemoteApiStepCounter'
        self.stepCounter = 0
        self.lastImageAcquisitionTime = -1
        sim.simxFinish(-1)  # just in case, close all opened connections
        self.id = sim.simxStart('192.168.15.50', 19999, True, True, 5000, 5)  # Connect to CoppeliaSim
        return self

    def __exit__(self, *err):
        sim.simxFinish(-1)


def get_content(root):
    sub_title_page = Label(root,
                           text="Laboratório de projetos III",

                           relief="solid",
                           font="Arail 20",
                           padx=root.winfo_width() / 2 - 158,
                           pady=10)
    sub_title_page.grid(row=0, columnspan=3, sticky=W + E)


def get_messagebbox():
    messagebox.showinfo("This is info")
    messagebox.showwarning("This is warn")
    messagebox.showerror("This is a error")
    messagebox.askokcancel("This is a error")
    messagebox.askyesno("This is a error")


def open_window():
    top = Toplevel()
    get_title(top)


def slider(root):
    hoist_value = IntVar()
    arm_value = IntVar()
    crab_value = IntVar()
    ROW_ARM = 1
    ROW_HOIST = ROW_ARM + 2
    ROW_CRAB = ROW_HOIST + 3
    ROWS = ROW_HOIST + ROW_ARM + ROW_CRAB

    hoist_height = Scale(root, from_=0, to=100, showvalue=0, variable=hoist_value,
                         command=lambda x: move_hoist(x))
    arm_angle = Scale(root, from_=0, to=100,
                      orient=HORIZONTAL, command=lambda x: move_arm(x),
                      showvalue=0, variable=arm_value)
    crab_position = Scale(root, from_=0, to=100,
                          orient=HORIZONTAL, command=lambda x: move_crab(x),
                          showvalue=0, variable=crab_value)

    arm_title = Label(root, text="Arm Angle(%):")
    arm_lb_value = Label(root, width=5, textvariable=arm_value)
    crab_title = Label(root, text="Crab position(%):")
    crab_lb_value = Label(root, width=5, textvariable=crab_value)
    hoist_title = Label(root, text="Hoist height(%):")
    hoist_lb_value = Label(root, width=5, textvariable=hoist_value)

    hoist_title.grid(row=ROW_ARM - 1, column=4)
    hoist_lb_value.grid(row=ROW_ARM - 1, column=5)
    hoist_height.grid(row=ROW_ARM, rowspan=ROWS - 1, column=4)

    arm_title.grid(row=ROW_ARM - 1, column=2)
    arm_lb_value.grid(row=ROW_ARM - 1, column=3)
    arm_angle.grid(row=ROW_ARM, column=2)

    crab_title.grid(row=ROW_CRAB - 2, column=2)
    crab_lb_value.grid(row=ROW_CRAB - 2, column=3)
    crab_position.grid(row=ROW_CRAB - 1, column=2)


def main():
    root = Tk()
    root.geometry("800x600")
    root.resizable(0, 0)
    get_title(root)
    get_content(root)
    frame_control = LabelFrame(root, text="Control Section")
    # button_right = Button(frame_control, text="Open", command=lambda: open_window())
    # get_ufmg_image(frame_control)
    slider(frame_control)
    # button_right.grid(row=0, column=1)
    frame_control.grid(row=1, column=0, sticky=W + E)
    get_footer(root)
    mainloop()


def get_footer(root):
    status = Label(root, text='This property can be between: {}'.format(1), bd=1, relief=SUNKEN, anchor=W)
    status.grid(row=5, column=0, columnspan=3, sticky=W + E)


def get_title(root):
    root.title('Lab Projetos 3 - Controladora teleoperada de Grua')
    root.iconbitmap('./assets/index.ico')


def get_ufmg_image(root):
    # All images and dynamic items shoul be here
    load_image = Image.open(UFMG_IMG_PATH)
    resized_image = load_image.resize((32, 32), Image.ANTIALIAS)
    ufmg_resized_image = ImageTk.PhotoImage(resized_image)
    logo_ufmg = Label(root, image=ufmg_resized_image)
    logo_ufmg.image = ufmg_resized_image
    logo_ufmg.grid(row=0, column=0, columnspan=1, rowspan=2,
                   sticky=W + N, padx=5, pady=5)


def move_arm(rotation):
    radians = (2 * math.pi * float(rotation)) / 100
    print("degrees are {}".format(str((360 * radians) / (2 * math.pi))))
    try:
        err_code, arm_actuator = sim.simxGetObjectHandle(client.id, "armActuator",
                                                         sim.simx_opmode_blocking)
        if err_code != 0:
            raise Exception("teste")
        sim.simxAddStatusbarMessage(client.id, 'Command angle rotation send: {}'.format(str(radians)),
                                    sim.simx_opmode_oneshot)
        err_code = sim.simxSetJointTargetPosition(client.id, arm_actuator, radians, sim.simx_opmode_streaming)
    except Exception:
        print("Code error is {}".format(err_code))


def move_hoist(height):
    final_height = (-0.68 * float(height)) / 100
    print("height is {}".format(str(final_height)))
    try:
        err_code, arm_actuator = sim.simxGetObjectHandle(client.id, "UpperMass",
                                                         sim.simx_opmode_blocking)
        if err_code != 0:
            raise Exception("teste")
        sim.simxAddStatusbarMessage(client.id, 'Command angle rotation send: {}'.format(str(final_height)),
                                    sim.simx_opmode_oneshot)
        err_code = sim.simxSetJointTargetPosition(client.id, arm_actuator, final_height, sim.simx_opmode_streaming)
    except Exception:
        print("Code error is {}".format(err_code))


def move_crab(position):
    final_position = (0.61 * float(position)) / 100
    print("Position is {}".format(str(final_position)))
    try:
        err_code, arm_actuator = sim.simxGetObjectHandle(client.id, "CrabMove",
                                                         sim.simx_opmode_blocking)
        if err_code != 0:
            raise Exception("teste")
        sim.simxAddStatusbarMessage(client.id, 'Crab position request is: {}'.format(str(final_position)),
                                    sim.simx_opmode_oneshot)
        err_code = sim.simxSetJointTargetPosition(client.id, arm_actuator, final_position, sim.simx_opmode_streaming)
    except Exception:
        print("Code error is {}".format(err_code))

def activate_magnet(teste):
    status = 'active' if teste else 'deactive'
    print("Magnet is {}".format(status))
    try:
        err_code, arm_actuator = sim.simxGetObjectHandle(client.id, "suctionPad",
                                                         sim.simx_opmode_oneshot)
        if err_code != 0:
            raise Exception("teste")
        sim.simxAddStatusbarMessage(client.id, 'Crab position request is: {}'.format(status),
                                    sim.simx_opmode_oneshot)
        err_code = sim.simxSetUserParameter(client.id, arm_actuator, status, sim.simx_opmode_streaming)
    except Exception:
        print("Code error is {}".format(err_code))


if __name__ == "__main__":
    with Client() as client:
        client.runInSynchronousMode = True
        print("running")
        if client.id != -1:
            print('Connected to remote API server')
            main()
        else:
            raise Exception("THis was not possible!")
