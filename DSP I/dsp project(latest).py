from tkinter import *
from tkinter import messagebox
from tkcalendar import *
from datetime import datetime
import random
import string


class FirstPage(Frame):
    def __init__(self, parent, controller):
        Frame.__init__(self, parent)
        self.configure(bg='white')
        self.img= PhotoImage(file='logo.png')
        self.resized_img = self.img.subsample(2)
        Label(self, image=self.resized_img, bg='white').place(x=50, y=100)

        frame = Frame(self, width=400, height=350, bg='sky blue')
        frame.place(x=450, y=70)

        heading = Label(frame, text='Login', fg='white', bg='sky blue', font=('Arial', 23, 'bold'))
        heading.place(x=150, y=5)

        usernameEntry = Entry(self, width=30, font=('Arial', 12, 'bold'))
        usernameEntry.place(x=505, y=150)
        usernameEntry.insert(0, 'Username')
        usernameEntry.bind('<FocusIn>', self.username_enter)

        passwordEntry = Entry(self, width=30, font=('Arial', 12, 'bold'))
        passwordEntry.place(x=505, y=220)
        passwordEntry.insert(0, 'Password')
        passwordEntry.bind('<FocusIn>', self.userpassword_enter)

        self.closeEye = PhotoImage(file='closeeyes.png')
        self.resized_closeEye = self.closeEye.subsample(10)
        eyeButton = Button(self, image=self.resized_closeEye, cursor='hand2')
        eyeButton.place(x=800, y=217)

        forgetButton = Button(self, text='Forgot Password?', font=('Arial', 10, 'bold'), bd=0, bg='sky blue',
                              cursor='hand2', activebackground='steel blue')
        forgetButton.place(x=715, y=260)

        def login():
            try:
                with open('credential.txt', 'r') as f:
                    info = f.readlines()
                    i = 0
                    for e in info:
                        u, p = e.split(',')
                        if u.strip() == usernameEntry.get() and p.strip() == passwordEntry.get():
                            controller.show_frame(ThirdPage)
                            i = 1
                            break
                    if i == 0:
                        messagebox.showinfo('Error', 'Please provide correct username and password!')
            except:
                messagebox.showinfo('Error', 'Please provide correct username and password!')

        loginButton = Button(self, text='Login', font=('Arial', 16, 'bold'), command=login)
        loginButton.place(x=500, y=300)

        sign_up_Label = Label(self, text='Dont have an account?', font=('Arial', 10, 'bold'), bg='sky blue')
        sign_up_Label.place(x=500, y=360)

        def register():
            controller.show_frame(SecondPage)

        newaccButton = Button(self, text='Create New Account', font=('Arial', 9, 'bold underline'), bd=0,
                                  bg='sky blue', cursor='hand2', activebackground='steel blue', command=register)
        newaccButton.place(x=660, y=360)



    def username_enter(self, event):
        if event.widget.get() == 'Username':
            event.widget.delete(0, END)

    def userpassword_enter(self, event):
        if event.widget.get() == 'Password':
            event.widget.delete(0, END)
            event.widget.config(show='*')


class SecondPage(Frame):
    def __init__(self, parent, controller):
        Frame.__init__(self, parent)
        self.configure(bg='white')
        self.head=Label(self,text='Create A New Account !',font=('Arial',20,'bold'),bg='white')
        self.head.pack(pady=70)
        l1 = Label(self, text='Username', font=('Arial', 10))
        l1.place(x=300, y=150)
        t1 = Entry(self, width=30, bd=3)
        t1.place(x=400, y=150)

        l2 = Label(self, text='Password', font=('Arial', 10))
        l2.place(x=300, y=200)
        t2 = Entry(self, width=30, show='*', bd=3)
        t2.place(x=400, y=200)

        l3 = Label(self, text='Confirm Password', font=('Arial', 10))
        l3.place(x=270, y=250)
        t3 = Entry(self, width=30, show='*', bd=3)
        t3.place(x=400, y=250)

        def check():
            if t1.get() != '' or t2.get() != '' or t3.get() != '':
                if t2.get() == t3.get():
                    with open('credential.txt', 'a') as f:
                        f.write(t1.get() + ',' + t2.get() + '\n')
                        messagebox.showinfo('Welcome', 'you are registered successfully!!')
                else:
                    messagebox.showinfo('Error', "Your password didn't get match!!")
            else:
                messagebox.showinfo('Error', "Please fill the complete field!!")

        submit = Button(self, text='Submit', font=('Arial', 15), bg='sky blue',cursor='hand2',command=check)
        submit.place(x=420, y=320)

        backlog= Button(self, text='Back To Login',font=('Arial',9,'bold underline'),bd=0,bg='white',cursor='hand2',
                        command=lambda: controller.show_frame(FirstPage))
        backlog.place(x=520, y=330)



class ThirdPage(Frame):
    def __init__(self, parent, controller):
        Frame.__init__(self, parent)
        self.configure(bg='white')
        self.homepage = Label(self, text="Welcome to Splash Mania Waterpark !", font=('Arial', 20, 'bold'), bg='white')
        self.homepage.pack(pady=20)
        self.hpimg = PhotoImage(file='waterpark.png')
        self.resized_hpimg = self.hpimg.subsample(2)
        Label(self, image=self.resized_hpimg).place(x=50, y=60)
        self.intro=Label(self, text="""
        Where nature meets fun, and where you can 
        spend the entire day splashing around under
        the sun! Experience the thrills and spills of a
        one-of-a-kind waterpark n SplashMania.Home 
        to 39 exhilarating slides and attractions that 
        cater to families, students, young working
        adults  and  thril  seekers of all kinds, this 
        waterpark  is  located  in  Gamuda  Cove,
        Selangor.
        """, font=('Arial', 15), bg='white', justify='left')
        self.intro.place(x=408, y=60)
        self.intro = Label(self,text='MYR80.00 - MYR125.00', font=('Arial', 20,'bold'), bg='white', justify='left')
        self.intro.place(x=460, y=330)

        bookingButton=Button(self, text='Book Now', font=('Arial',17),cursor='hand2',
                             command=lambda: controller.show_frame(FourthPage))
        bookingButton.place(x=460, y=390)



class FourthPage(Frame):
    visitor = {}
    def __init__(self, parent, controller):
        Frame.__init__(self, parent)
        self.configure(bg='white')
        self.selectslot = Label(self, text='Select Slot To Book', font=('Arial',15), bg='white')
        self.selectslot.pack(pady=10)

        self.selectdate = Label(self, text='Select booking date:', font=('Arial', 12), bg='white')
        self.selectdate.place(x=40, y=70)
        self.selectdateEntry = Entry(self, bg='white', font=('Arial', 11))
        self.selectdateEntry.place(x=200, y=70, width=150)
        self.pick_date_button = Button(self, text='Pick Date', command=self.pick_date)
        self.pick_date_button.pack(padx=20,pady=17)

        self.child_ticket_label = Label(self, text='Number of Child (90cm-120cm) ', font=('Arial', 12),bg='white')
        self.child_ticket_label.place(x=40,y=120)
        self.child_pricelabel=Label(self,text='MYR',font=('Arial', 12),bg='white')
        self.child_pricelabel.place(x=450, y=120)
        self.child_ticket_price_var = StringVar()
        self.child_ticket_price_label = Label(self, textvariable=self.child_ticket_price_var, font=('Arial', 12),
                                              bg='white')
        self.child_ticket_price_label.place(x=490, y=120)
        self.child_spinner = Spinbox(self, from_=0, to=10,width=5,command=self.calculate_total)
        self.child_spinner.place(x=580, y=120)

        self.adult_ticket_label = Label(self, text='Number of Adult (above 120cm) ', font=('Arial', 12), bg='white')
        self.adult_ticket_label.place(x=40, y=170)
        self.adult_pricelabel = Label(self, text='MYR', font=('Arial', 12), bg='white')
        self.adult_pricelabel.place(x=450, y=170)
        self.adult_ticket_price_var = StringVar()
        self.adult_ticket_price_label = Label(self, textvariable=self.adult_ticket_price_var, font=('Arial', 12),
                                              bg='white')
        self.adult_ticket_price_label.place(x=490, y=170)
        self.adult_spinner = Spinbox(self, from_=0, to=10,width=5,command=self.calculate_total)
        self.adult_spinner.place(x=580, y=170)

        self.seniorcitizen_ticket_label = Label(self, text='Number of Senior Citizen (Age 60 years and Above) ',
                                                font=('Arial', 12), bg='white')
        self.seniorcitizen_ticket_label.place(x=40, y=220)
        self.sc_pricelabel = Label(self, text='MYR', font=('Arial', 12), bg='white')
        self.sc_pricelabel.place(x=450, y=220)
        self.seniorcitizen_ticket_price_var = StringVar()
        self.seniorcitizen_ticket_price_label = Label(self, textvariable=self.seniorcitizen_ticket_price_var,
                                                      font=('Arial', 12),bg='white')
        self.seniorcitizen_ticket_price_label.place(x=490, y=220)
        self.seniorcitizen_spinner = Spinbox(self, from_=0, to=10,width=5,command=self.calculate_total)
        self.seniorcitizen_spinner.place(x=580, y=220)

        self.total_ticket_label = Label(self, text='Total Tickets:', font=('Arial', 12), bg='white')
        self.total_ticket_label.place(x=40, y=270)
        self.total_ticket_count_var = StringVar()
        self.total_ticket_count_label = Label(self, textvariable=self.total_ticket_count_var, font=('Arial', 12),
                                              bg='white')
        self.total_ticket_count_label.place(x=150, y=270)

        self.total_price_label = Label(self, text='Total Price:', font=('Arial', 12), bg='white')
        self.total_price_label.place(x=40, y=320)
        self.total_ticket_price_var = StringVar()
        self.total_ticket_price_label = Label(self, textvariable=self.total_ticket_price_var, font=('Arial', 12),
                                              bg='white')
        self.total_ticket_price_label.place(x=150, y=320)

        buynowButton = Button(self, text='Buy Now', font=('Arial', 17), cursor='hand2',
                              command=lambda: self.buy_now(controller))
        buynowButton.place(x=40, y=400)

    def pick_date(self):
        date_window = Toplevel(self)
        date_window.title('Select Your Booking Date')
        date_window.geometry('250x220+590+370')

        cal = Calendar(date_window, selectmode='day', date_pattern='yyyy-mm-dd')
        cal.pack(pady=10)

        set_button = Button(date_window, text='Set', command=lambda: self.set_date(cal))
        set_button.place(x=110, y=195)

    def set_date(self, cal):
        selected_date = cal.get_date()
        if selected_date in FourthPage.visitor and FourthPage.visitor[selected_date] >= 500:
            messagebox.showinfo('Error','Maximum number of visitors reached for this date. Please choose another date.')
            return
        self.selectdateEntry.config(state=NORMAL)
        self.selectdateEntry.delete(0, END)
        self.selectdateEntry.insert(0,selected_date)
        self.selectdateEntry.config(state='readonly')
        if selected_date in FourthPage.visitor:
            FourthPage.visitor[selected_date] += 1
        else:
            FourthPage.visitor[selected_date] = 1
        date_obj = datetime.strptime(selected_date, '%Y-%m-%d')
        weekday = date_obj.weekday()

        if weekday < 4:
            child_ticket_price = '80.00'
            adult_ticket_price = '110.00'
            seniorcitizen_ticket_price='80.00'
        else:
            child_ticket_price = '95.00'
            adult_ticket_price = '125.00'
            seniorcitizen_ticket_price = '95.00'
        self.child_ticket_price_var.set(child_ticket_price)
        self.adult_ticket_price_var.set(adult_ticket_price)
        self.seniorcitizen_ticket_price_var.set(seniorcitizen_ticket_price)

    def calculate_total(self):
        child_count = int(self.child_spinner.get())
        adult_count = int(self.adult_spinner.get())
        seniorcitizen_count = int(self.seniorcitizen_spinner.get())

        total_count = child_count + adult_count + seniorcitizen_count
        self.total_ticket_count_var.set(str(total_count))

        child_ticket_price = float(self.child_ticket_price_var.get())
        adult_ticket_price = float(self.adult_ticket_price_var.get())
        seniorcitizen_ticket_price = float(self.seniorcitizen_ticket_price_var.get())

        total_price = (child_count * child_ticket_price +
                       adult_count * adult_ticket_price +
                       seniorcitizen_count * seniorcitizen_ticket_price)

        self.total_ticket_price_var.set(f'MYR {total_price:.2f}')

    def get_total_count(self):
        child_count = int(self.child_spinner.get())
        adult_count = int(self.adult_spinner.get())
        seniorcitizen_count = int(self.seniorcitizen_spinner.get())
        return child_count + adult_count + seniorcitizen_count

    def buy_now(self, controller):
        selected_date = self.selectdateEntry.get()

        if not selected_date:
            messagebox.showinfo('Error', 'Please select a booking date before proceeding.')
            return
        total_count = self.get_total_count()
        if total_count == 0:
            messagebox.showinfo('Error', 'Please select at least one ticket before proceeding.')
            return
        if selected_date in FourthPage.visitor and FourthPage.visitor[selected_date] >= 500:
            messagebox.showinfo('Error','Maximum number of visitors reached for this date. Please choose another date.')
            return
        controller.show_frame(FifthPage)


class FifthPage(Frame):
    def __init__(self, parent, controller):
        Frame.__init__(self, parent)
        self.configure(bg='white')
        self.controller = controller
        booking_detail_label = Label(self, text='Booking Detail', font=('Arial', 15, 'bold'), bg='white')
        booking_detail_label.place(x=370, y=30)
        self.name_label = Label(self, text='Name:', font=('Arial', 12), bg='white')
        self.name_label.place(x=350, y=100)
        self.name_entry = Entry(self, width=20, font=('Arial', 12), bd=2)
        self.name_entry.place(x=420, y=100)

        self.ic_label = Label(self, text="IC No:", font=('Arial', 12), bg='white')
        self.ic_label.place(x=350, y=150)
        self.ic_entry = Entry(self, width=20, font=('Arial', 12), bd=2)
        self.ic_entry.place(x=420, y=150)

        self.phone_label = Label(self, text="Contact No:", font=('Arial', 12), bg='white')
        self.phone_label.place(x=310, y=200)
        self.phone_entry = Entry(self, width=20, font=('Arial', 12), bd=2)
        self.phone_entry.place(x=420, y=200)

        self.email_label = Label(self, text="Email:", font=('Arial', 12), bg='white')
        self.email_label.place(x=350, y=250)
        self.email_entry = Entry(self, width=20, font=('Arial', 12), bd=2)
        self.email_entry.place(x=420, y=250)

        self.resident_status_label = Label(self, text="Resident Satus:", font=('Arial', 12), bg='white')
        self.resident_status_label.place(x=300, y=300)

        options = ["Resident", "Non-Resident"]
        self.resident_status_var = StringVar()
        self.resident_status_var.set(options[0])
        self.resident_status_menu = OptionMenu(self, self.resident_status_var, *options)
        self.resident_status_menu.place(x=420, y=300)

        nextButton = Button(self, text='Next', font=('Arial', 17), cursor='hand2',
                            command=self.nextPage)
        nextButton.place(x=400, y=400)

    def nextPage(self):
        if not self.name_entry.get() or not self.ic_entry.get() or not self.phone_entry.get() or not self.email_entry.get():
            messagebox.showwarning("Missing Information", "Please complete your booking detail.")

        else:
            booking_info = {
                'Name': self.name_entry.get(),
                'IC': self.ic_entry.get(),
                'Contact No': self.phone_entry.get(),
                'Email': self.email_entry.get(),
                'Resident Status': self.resident_status_var.get()}
            self.controller.show_frame(SixthPage, booking_info)


class SixthPage(Frame):
    def __init__(self, parent, controller):
        Frame.__init__(self, parent)
        self.configure(bg='white')
        bk_label = Label(self, text='Booking Confirmation', font=('Arial', 18,'bold underline'), bg='white')
        bk_label.place(x=310, y=10)
        check_label = Label(self, text='Please confirm your booking details.', font=('Arial', 12, 'bold'), bg='white')
        check_label.place(x=300, y=60)
        check2_label = Label(self,text='Once the booking is confirmed, booking information will be send to your email.',font=('Arial', 12, 'bold'), bg='white')
        check2_label.place(x=150, y=90)

        checkoutButton = Button(self, text='Checkout', font=('Arial', 12), cursor='hand2',
                                command=lambda: controller.show_frame(SeventhPage))
        checkoutButton.place(x=450, y=400)
        backButton = Button(self, text='Back', font=('Arial', 12), cursor='hand2',
                                command=lambda: controller.show_frame(FifthPage))
        backButton.place(x=350, y=400)
        self.name_label = Label(self, text="Name:", bg='white', font=('Arial', 12))
        self.name_label.place(x=370,y=130)

        self.ic_label = Label(self, text="IC:", bg='white', font=('Arial', 12))
        self.ic_label.place(x=390,y=180)

        self.phone_label = Label(self, text="Contact No:", bg='white', font=('Arial', 12))
        self.phone_label .place(x=330,y=230)

        self.email_label = Label(self, text="Email:", bg='white', font=('Arial', 12))
        self.email_label.place(x=370,y=280)

        self.resident_status_label = Label(self, text="Resident Satus:", font=('Arial', 12), bg='white')
        self.resident_status_label.place(x=340, y=330)

    def display_bk_detail (self, booking_info):
        self.name_label.config(text=f"Name: {booking_info.get('Name', '')}")
        self.ic_label.config(text=f"IC: {booking_info.get('IC', '')}")
        self.phone_label.config(text=f"Contact No: {booking_info.get('Contact No', '')}")
        self.email_label.config(text=f"Email: {booking_info.get('Email', '')}")
        self.resident_status_label.config(text=f"Resident Status: {booking_info.get('Resident Status', '')}")

class SeventhPage(Frame):
    def __init__(self, parent, controller):
        Frame.__init__(self, parent)
        self.configure(bg='white')
        self.tickimg = PhotoImage(file='tick.png')
        self.resized_tickimg = self.tickimg.subsample(5)
        Label(self, image=self.resized_tickimg).place(x=370, y=10)

        bkconf_label = Label(self, text="Booking Confirmed !", font=('Arial', 22, 'bold'), bg='white')
        bkconf_label.place(x=320, y=200)

        booking_reference = self.generate_booking_reference()

        bkref_label = Label(self, text=(f"Your Booking Reference:{booking_reference}"), font=('Arial',17, 'bold'), bg='white')
        bkref_label.place(x=260, y=250)

        instr_label = Label(self, text="""
        Please make your payment at entrance counter by showing your booking reference.
        Please contact 03 9322 1811 (customer service) if you 
        wish to cancel your booking.Thanks you! """,font=('Arial', 12), bg='white', justify='center')
        instr_label.place(x=150, y=280)

        logoutButton = Button(self, text='Log out', font=('Arial', 12), command=exit)
        logoutButton.place(x=420, y=380)

    def generate_booking_reference(self):
        random_part = ''.join(random.choices(string.ascii_uppercase + string.digits, k=6))
        return f"SMBR{random_part}"

class Application(Tk):
    def __init__(self, *args, **kwargs):
        Tk.__init__(self, *args, **kwargs)
        self.title('Splash Mania Water Park')
        window = Frame(self)
        window.pack()

        window.grid_rowconfigure(0, minsize = 500)
        window.grid_columnconfigure(0, minsize=900)

        self.frames = {}
        for F in (FirstPage, SecondPage, ThirdPage, FourthPage, FifthPage,SixthPage,SeventhPage):
            frame = F(window, self)
            self.frames[F] = frame
            frame.grid(row = 0, column = 0, sticky='nsew')

        self.show_frame(FirstPage)

    def show_frame(self, page, *args, **kwargs):
        frame = self.frames[page]

        if hasattr(frame, 'display_bk_detail'):
            frame.display_bk_detail(*args, **kwargs)
        frame.tkraise()

app = Application()
app.resizable(False,False)
app.mainloop()