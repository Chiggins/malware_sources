
#pragma once

#include <windows.h>
#include <iostream>

namespace GUI {

	using namespace System;
	using namespace System::ComponentModel;
	using namespace System::Collections;
	using namespace System::Windows::Forms;
	using namespace System::Data;
	using namespace System::Drawing;
	using namespace System::Runtime::InteropServices;

	[DllImport("user32.dll", EntryPoint = "MessageBox")]
   int MessageBox(void* hWnd, char * lpText, char * lpCaption, 
                  unsigned int uType);

	/// <summary>
	/// Summary for USG
	/// </summary>
	public ref class USG : public System::Windows::Forms::Form
	{
	public:
		USG(void)
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
		~USG()
		{
			if (components)
			{
				delete components;
			}
		}
	private: System::Windows::Forms::ProgressBar^  progressBar1;
	private: System::Windows::Forms::ListBox^  list;
	private: System::Windows::Forms::Timer^  timer1;
	private: System::ComponentModel::IContainer^  components;
	protected: 

	private:
		/// <summary>
		/// Required designer variable.
		/// </summary>


#pragma region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		void InitializeComponent(void)
		{
			this->components = (gcnew System::ComponentModel::Container());
			System::ComponentModel::ComponentResourceManager^  resources = (gcnew System::ComponentModel::ComponentResourceManager(USG::typeid));
			this->progressBar1 = (gcnew System::Windows::Forms::ProgressBar());
			this->list = (gcnew System::Windows::Forms::ListBox());
			this->timer1 = (gcnew System::Windows::Forms::Timer(this->components));
			this->SuspendLayout();
			// 
			// progressBar1
			// 
			this->progressBar1->Location = System::Drawing::Point(37, 134);
			this->progressBar1->Name = L"progressBar1";
			this->progressBar1->Size = System::Drawing::Size(188, 23);
			this->progressBar1->TabIndex = 0;
			// 
			// list
			// 
			this->list->BackColor = System::Drawing::Color::FromArgb(static_cast<System::Int32>(static_cast<System::Byte>(60)), static_cast<System::Int32>(static_cast<System::Byte>(60)), 
				static_cast<System::Int32>(static_cast<System::Byte>(60)));
			this->list->ForeColor = System::Drawing::SystemColors::Info;
			this->list->FormattingEnabled = true;
			this->list->ItemHeight = 15;
			this->list->Location = System::Drawing::Point(37, 37);
			this->list->Name = L"list";
			this->list->Size = System::Drawing::Size(188, 64);
			this->list->TabIndex = 1;
			this->list->SelectedIndexChanged += gcnew System::EventHandler(this, &USG::list_SelectedIndexChanged);
			// 
			// timer1
			// 
			this->timer1->Enabled = true;
			this->timer1->Interval = 2000;
			this->timer1->Tick += gcnew System::EventHandler(this, &USG::timer1_Tick);
			// 
			// USG
			// 
			this->AutoScaleDimensions = System::Drawing::SizeF(7, 15);
			this->AutoScaleMode = System::Windows::Forms::AutoScaleMode::Font;
			this->BackColor = System::Drawing::Color::FromArgb(static_cast<System::Int32>(static_cast<System::Byte>(34)), static_cast<System::Int32>(static_cast<System::Byte>(34)), 
				static_cast<System::Int32>(static_cast<System::Byte>(34)));
			this->ClientSize = System::Drawing::Size(263, 180);
			this->Controls->Add(this->list);
			this->Controls->Add(this->progressBar1);
			this->Font = (gcnew System::Drawing::Font(L"Arial", 9, System::Drawing::FontStyle::Bold, System::Drawing::GraphicsUnit::Point, static_cast<System::Byte>(0)));
			this->FormBorderStyle = System::Windows::Forms::FormBorderStyle::Fixed3D;
			this->Icon = (cli::safe_cast<System::Drawing::Icon^  >(resources->GetObject(L"$this.Icon")));
			this->Name = L"USG";
			this->StartPosition = System::Windows::Forms::FormStartPosition::CenterScreen;
			this->Text = L"Crypting...";
			this->Load += gcnew System::EventHandler(this, &USG::USG_Load);
			this->ResumeLayout(false);

		}
#pragma endregion

    int g;
	char * fsize;
	char * full;

	public:  void pike(int ajoj)
	{
		g = ajoj;
		fsize = new char[MAX_PATH];
		full = new char[MAX_PATH];
		full[0] = '\0';
		itoa(g,fsize,10);
		strcat(full,"File size: ");
		strcat(full,fsize);
		strcat(full," bytes");
	}

			 public:  void kraj()
	{
		this->Close();
	}

	private: System::Void USG_Load(System::Object^  sender, System::EventArgs^  e) {

				 
			 }
	private: System::Void list_SelectedIndexChanged(System::Object^  sender, System::EventArgs^  e) {
			 }
private: System::Void timer1_Tick(System::Object^  sender, System::EventArgs^  e) {

			 this->progressBar1->Maximum = g;

			 list->Items->Add(gcnew String(full));

				 for(float i = 0;i<g;i++)
				 {
					       this->progressBar1->Increment(1);

						   if(this->progressBar1->Value == g/90)
						   {

                              
							  //Sleep(300);

						   }

							 if(this->progressBar1->Value == g/40)
						   {

                              list->Items->Add("Getting Bytes");
							  //Sleep(300);

						   }

							 if(this->progressBar1->Value == g/30)
						   {

                              list->Items->Add("Protecting");
							  //Sleep(300);

						   }


							  if(this->progressBar1->Value == g/10)
						   {

                              list->Items->Add("Protected");
							  //Sleep(300);

						   }

							   if(this->progressBar1->Value == g)
						   {

                              this->Close();

						   }


				 }

				 timer1->Enabled = false;


		 }
};
}
