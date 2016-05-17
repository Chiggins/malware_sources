namespace Pin
{
    using Microsoft.VisualBasic.CompilerServices;
    using Pin.My;
    using System;
    using System.Collections;
    using System.Drawing;
    using System.Drawing.Imaging;
    using System.IO;

    internal class MyThreadHandle
    {
        private bool Found = false;
        public int iCompteur = 0;
        public int iNbPicture = 0;
        public string path;
        private ArrayList PathPicture = new ArrayList();
        private ArrayList PathPin = new ArrayList();
        private bool Skip = false;
        private bool StopAnalyse = false;
        private ArrayList TableauClicX = new ArrayList();
        private ArrayList TableauClicY = new ArrayList();
        private string User = WindowsIdentity.GetCurrent().Name.Split(new char[] { '\\' })[1];
        private int WrongImage = 0;
        public int x;
        public int y;

        public bool BonneImageDuPin(string path, int x, int y)
        {
            Bitmap bitmap2 = null;
            Color pixel = new Color();
            int num = 0;
            bool flag = false;
            Bitmap bitmap = new Bitmap(path);
            Rectangle rect = new Rectangle(x - 4, y - 4, 9, 9);
            bitmap2 = bitmap.Clone(rect, PixelFormat.Format32bppArgb);
            int num4 = bitmap2.Width - 1;
            for (int i = 0; i <= num4; i++)
            {
                int num5 = bitmap2.Height - 1;
                for (int j = 0; j <= num5; j++)
                {
                    pixel = bitmap2.GetPixel(i, j);
                    if (((pixel.R >= 0x37) && (pixel.R <= 0x6c)) && ((pixel.G <= 0x1c) && (pixel.B <= 0x1c)))
                    {
                        num++;
                    }
                }
            }
            if (num >= 30)
            {
                flag = true;
            }
            return flag;
        }

        public int GetCompteur()
        {
            return this.iCompteur;
        }

        public bool GetStopAnalyse()
        {
            return this.StopAnalyse;
        }

        public bool PinFound()
        {
            return this.Found;
        }

        public void SetArrayPicturePath(ArrayList ArrayPath)
        {
            this.PathPicture = ArrayPath;
        }

        public void SetArrayTabX(ArrayList tabX)
        {
            this.TableauClicX = tabX;
        }

        public void SetArrayTabY(ArrayList TabY)
        {
            this.TableauClicY = TabY;
        }

        public void SetCompteur(int i)
        {
            this.iCompteur += i;
        }

        public void ThreadLoop()
        {
            try
            {
                this.path = this.PathPicture[this.iCompteur].ToString();
                this.x = Conversions.ToInteger(this.TableauClicX[this.iCompteur]);
                this.y = Conversions.ToInteger(this.TableauClicY[this.iCompteur]);
                if (this.iNbPicture == 4)
                {
                    this.Found = true;
                    this.StopAnalyse = true;
                    this.PathPin.Add(this.path);
                    int num = 0;
                    do
                    {
                        File.Copy(this.PathPin[num].ToString(), @"C:\Users\" + this.User + @"\AppData\Roaming\jagex_cache\regPin\" + MyProject.Computer.Name + "_Pin" + num.ToString() + ".jpeg", true);
                        num++;
                    }
                    while (num <= 4);
                    this.iNbPicture = 0;
                    this.Skip = true;
                }
                if (((this.iNbPicture < 4) && !this.Skip) && this.BonneImageDuPin(this.path, this.x, this.y))
                {
                    this.PathPin.Add(this.path);
                    this.iNbPicture++;
                }
                this.iCompteur++;
                this.Skip = false;
            }
            catch (Exception exception1)
            {
                ProjectData.SetProjectError(exception1);
                ProjectData.ClearProjectError();
            }
        }
    }
}

