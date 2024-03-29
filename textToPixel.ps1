function GenerateForm {
    ########################################################################
    # Author : Elwan Mayencourt // MayencourtE@studentfr.ch
    # Date : 12.09.2019
    # This script encrypt text into image and decrypt it
    ########################################################################

    #region Import the Assemblies
    [reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
    [reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
    #endregion

    #region Generated Form Objects
    $form1 = New-Object System.Windows.Forms.Form
    $Square = New-Object System.Windows.Forms.RadioButton
    $Line = New-Object System.Windows.Forms.RadioButton
    $label7 = New-Object System.Windows.Forms.Label
    $textFileName = New-Object System.Windows.Forms.TextBox
    $label6 = New-Object System.Windows.Forms.Label
    $label5 = New-Object System.Windows.Forms.Label
    $label4 = New-Object System.Windows.Forms.Label
    $panel1 = New-Object System.Windows.Forms.Panel
    $textFileDecrypt = New-Object System.Windows.Forms.TextBox
    $chooseFile = New-Object System.Windows.Forms.Button
    $label3 = New-Object System.Windows.Forms.Label
    $textArea = New-Object System.Windows.Forms.RichTextBox
    $textToEncrypt = New-Object System.Windows.Forms.TextBox
    $label2 = New-Object System.Windows.Forms.Label
    $textFolder = New-Object System.Windows.Forms.TextBox
    $label1 = New-Object System.Windows.Forms.Label
    $chooseFolder = New-Object System.Windows.Forms.Button
    $decrypt = New-Object System.Windows.Forms.Button
    $encrypt = New-Object System.Windows.Forms.Button
    $InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState



    # Create authorized char array
    $character = "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", " ", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "!", "#", "$", "%", "&", "\", "'", "(", ")", "*", "+", "-", ".", ",", "/", ":", ";", "?", "@", "[", "]", "^", "_", "~", "}", "{", "=", "é", "ö", "è", "ü", "à", "ä", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"


    # Execute choose button
    $chooseFolder_OnClick = 
    {
        Add-Type -AssemblyName System.Windows.Forms
        $FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
	 
        [void]$FolderBrowser.ShowDialog()
        $textFolder.Text = $FolderBrowser.SelectedPath
	

    }
	
    # Execution choose file
    $chooseFile_OnClick = 
    {
        Add-Type -AssemblyName System.Windows.Forms
        $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog
        $FileBrowser.filter = "Png (*.png)| *.png"

        [void]$FileBrowser.ShowDialog()
        $textFileDecrypt.Text = $FileBrowser.FileName

    }


    $encrypt_OnClick = 
    {


        #Set the test boolean to false
        $testFolder = $false
        $testFile = $false
        $testTextEncrypt = $false

        #Get input folder
        $folder = $textFolder.Text

        #Check if textBox folder is empty and then turn to true the test boolean
        if ($folder -eq "") {
            $testFolder = $true
            $textFolder.ForeColor = [System.Drawing.Color]::FromArgb(255, 255, 0, 0)
            $textFolder.text = "Choose a folder"
        }
        #Get the fileName
        $file = $textFileName.Text

        #Check if textBox file is empty and then turn to true the test boolean
        if ($file -eq "") {
            $testFile = $true
            $textFileName.text = "Enter file name"
        }
        #Get the text to encrypt
        $input = $textToEncrypt.Text
        #Check if textBox textToEncrypt is empty and then turn to true the test boolean
        if ($input -eq "") {
            $testTextEncrypt = $true
            $textToEncrypt.text = "Enter what you want to encrypt"
        }
        #Transform the string to an array of char
        $msg = $input.toCharArray()

        #Check if all input is correct
        if ($testFolder -eq $false -and $testFile -eq $false -and $testTextEncrypt -eq $false) {

            #Get size of the input string
            $length = $input.Length

            #Set filename
            $fileName = "$folder\$file.png"
		
            $testError = $false
            foreach ($letter in $msg ) {

                #check if there is invalid char in the textBox
                if ($character.Contains("$letter") -ne $true) {
                    $textToEncrypt.text = "Can't use $letter char"
                    $testError = $true
                }
 
            }
            if ($testError -eq $false) {
		
                #Do if radio button line is checked
                if ($Line.Checked -eq $true) {
                    $bmp = new-object System.Drawing.Bitmap ($length), 1 
                    $i = 0
                    foreach ($letter in $msg ) {
                        $index = [array]::indexof($character, "$letter")
                        $g = get-random -minimum 0 -maximum 255
                        $b = get-random -minimum 0 -maximum 255
                        $bmp.SetPixel(($i), 0, [System.Drawing.Color]::FromArgb($index, $g, $b))
                        $i++
                    }

                }
		
                #Do if Square radio button is checked
                else {
                    #Do the square root of the size 
                    $carre = [math]::Ceiling([math]::Sqrt($length))
                    $carre = [int]$carre
                    $bmp = new-object System.Drawing.Bitmap ($carre, $carre)
                    $i = 0
                    #Draw the image by pixel
                    foreach ($letter in $msg ) {
                        $index = [array]::indexof($character, "$letter")

                        #Put random value for the green and blue value of the pixel
                        $g = get-random -minimum 0 -maximum 255
                        $b = get-random -minimum 0 -maximum 255
				
                        $bmp.SetPixel(($i), ($j), [System.Drawing.Color]::FromArgb($index, $g, $b))

			
                        $i += 1
				
                        #Go to the next line
                        if ($i -eq $carre) {
                            $i = 0
                            $j += 1
                        }

                    }
                }

                #Save the image to the selected folder
                $bmp.Save($filename) 
                $file = Get-Item $filename
                $file.CreationTime = "11.09.2001" #Homage for the 11.09.2001, set the creation time of the image
                #Open the image  
                Invoke-Item $filename 
                $bmp.Dispose()
                $textArea.AppendText("Image  $filename has been created successfully`n")
            }
        }

    }

    #Decrypt image
    $decrypt_OnClick = 
    {
        
        $testError = $false
        $file = $textFileDecrypt.Text

        Try {
            $image = [System.Drawing.Image]::FromFile($file)
            $fileDate = Get-Item $file

        }
        Catch {
            $testError = $true
        }
        if ($fileDate.CreationTime -ne "11.09.2001 00:00") {
            #Omage for the 11.09.2001, decrypt only image with this creation date
            $testError = $true
            $textArea.AppendText("You can't open an image that has not been encrypted with this program`n")
        }
  
        $width = $image.Width
        $height = $image.Height

        if ($testError -eq $false) {
            #Decrypt the square image
            if ($height -gt 1) {
                for ($i = 0; $i -lt $width; $i++) {
                    for ($j = 0; $j -lt $width; $j++) {
                        if ($image.GetPixel($j, $i).R -eq 0 -and $image.GetPixel($j, $i).G -eq 0 -and $image.GetPixel($j, $i).B -eq 0) {
                            #Do nothing because pixel doesn't exit(blank pixel)
                        }
                        else {
						
                            $pixel = $image.GetPixel($j, $i).R
                            try {
                                $value = $character.GetValue($pixel)
                            }
                            Catch {
                                break
                                
                            }
                            
                            $result = $result + $value

                        }
                    
                    }
                }
            } 

            #Decrypt the line image
            else {
                for ($j = 0; $j -lt $width; $j++) {
                    $pixel = $image.GetPixel($j, 0).R
                    try {
                        $value = $character.GetValue($pixel)
                    }
                    Catch {
                        break
                        
                    }
                    $result = $result + $value
                }
            }
		

            #Print the result of the decrypt
            $textArea.AppendText("Result decryption of $file = $result`n")
            $image.Dispose()
        }
        else {
            $textFileDecrypt.text = "Choose a file"
        }

    }




    $OnLoadForm_StateCorrection =
    { #Correct the initial state of the form to prevent the .Net maximized form issue
        $form1.WindowState = $InitialFormWindowState
    }

    #----------------------------------------------
    #region Generated Form Code
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = 444
    $System_Drawing_Size.Width = 640
    $form1.ClientSize = $System_Drawing_Size
    $form1.DataBindings.DefaultDataSourceUpdateMode = 0
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = 483
    $System_Drawing_Size.Width = 656
    $form1.MaximumSize = $System_Drawing_Size
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = 483
    $System_Drawing_Size.Width = 656
    $form1.MinimumSize = $System_Drawing_Size
    $form1.Name = "form1"
    $form1.Text = "Images Encrypter/Decrypter"


    $Square.DataBindings.DefaultDataSourceUpdateMode = 0

    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 571
    $System_Drawing_Point.Y = 136
    $Square.Location = $System_Drawing_Point
    $Square.Name = "Square"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = 24
    $System_Drawing_Size.Width = 63
    $Square.Size = $System_Drawing_Size
    $Square.TabIndex = 19
    $Square.TabStop = $True
    $Square.Text = "Square"
    $Square.UseVisualStyleBackColor = $True

    $form1.Controls.Add($Square)


    $Line.DataBindings.DefaultDataSourceUpdateMode = 0

    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 514
    $System_Drawing_Point.Y = 136
    $Line.Location = $System_Drawing_Point
    $Line.Name = "Line"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = 24
    $System_Drawing_Size.Width = 51
    $Line.Size = $System_Drawing_Size
    $Line.TabIndex = 18
    $Line.TabStop = $True
    $Line.Text = "Line"
    $Line.UseVisualStyleBackColor = $True
    $line.Checked = $true
    $form1.Controls.Add($Line)

    $label7.DataBindings.DefaultDataSourceUpdateMode = 0

    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 22
    $System_Drawing_Point.Y = 69
    $label7.Location = $System_Drawing_Point
    $label7.Name = "label7"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = 23
    $System_Drawing_Size.Width = 173
    $label7.Size = $System_Drawing_Size
    $label7.TabIndex = 17
    $label7.Text = "Enter file name (no extension)"

    $form1.Controls.Add($label7)

    $textFileName.DataBindings.DefaultDataSourceUpdateMode = 0
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 201
    $System_Drawing_Point.Y = 66
    $textFileName.Location = $System_Drawing_Point
    $textFileName.Name = "textFileName"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = 20
    $System_Drawing_Size.Width = 294
    $textFileName.Size = $System_Drawing_Size
    $textFileName.TabIndex = 16
    $textFileName.text = "result"

    $form1.Controls.Add($textFileName)

    $label6.DataBindings.DefaultDataSourceUpdateMode = 0
    $label6.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 14.25, 1, 3, 0)

    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 282
    $System_Drawing_Point.Y = 171
    $label6.Location = $System_Drawing_Point
    $label6.Name = "label6"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = 23
    $System_Drawing_Size.Width = 100
    $label6.Size = $System_Drawing_Size
    $label6.TabIndex = 15
    $label6.Text = "Decrypt"

    $form1.Controls.Add($label6)

    $label5.DataBindings.DefaultDataSourceUpdateMode = 0

    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 22
    $System_Drawing_Point.Y = 205
    $label5.Location = $System_Drawing_Point
    $label5.Name = "label5"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = 23
    $System_Drawing_Size.Width = 151
    $label5.Size = $System_Drawing_Size
    $label5.TabIndex = 14
    $label5.Text = "Choose file to decrypt"

    $form1.Controls.Add($label5)

    $label4.DataBindings.DefaultDataSourceUpdateMode = 0
    $label4.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 14.25, 1, 3, 0)

    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 282
    $System_Drawing_Point.Y = -1
    $label4.Location = $System_Drawing_Point
    $label4.Name = "label4"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = 23
    $System_Drawing_Size.Width = 100
    $label4.Size = $System_Drawing_Size
    $label4.TabIndex = 13
    $label4.Text = "Encrypt"

    $form1.Controls.Add($label4)

    $panel1.BackColor = [System.Drawing.Color]::FromArgb(255, 0, 0, 0)

    $panel1.DataBindings.DefaultDataSourceUpdateMode = 0
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 0
    $System_Drawing_Point.Y = 166
    $panel1.Location = $System_Drawing_Point
    $panel1.Name = "panel1"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = 2
    $System_Drawing_Size.Width = 645
    $panel1.Size = $System_Drawing_Size
    $panel1.TabIndex = 12

    $form1.Controls.Add($panel1)

    $textFileDecrypt.DataBindings.DefaultDataSourceUpdateMode = 0
    $textFileDecrypt.Enabled = $False
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 201
    $System_Drawing_Point.Y = 208
    $textFileDecrypt.Location = $System_Drawing_Point
    $textFileDecrypt.Name = "textFileDecrypt"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = 20
    $System_Drawing_Size.Width = 294
    $textFileDecrypt.Size = $System_Drawing_Size
    $textFileDecrypt.TabIndex = 11
    $textFileDecrypt.Text = "$env:USERPROFILE\desktop\result.png"

    $form1.Controls.Add($textFileDecrypt)


    $chooseFile.DataBindings.DefaultDataSourceUpdateMode = 0

    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 520
    $System_Drawing_Point.Y = 205
    $chooseFile.Location = $System_Drawing_Point
    $chooseFile.Name = "chooseFile"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = 23
    $System_Drawing_Size.Width = 75
    $chooseFile.Size = $System_Drawing_Size
    $chooseFile.TabIndex = 10
    $chooseFile.Text = "Choose file"
    $chooseFile.UseVisualStyleBackColor = $True
    $chooseFile.add_Click($chooseFile_OnClick)

    $form1.Controls.Add($chooseFile)

    $label3.DataBindings.DefaultDataSourceUpdateMode = 0

    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 22
    $System_Drawing_Point.Y = 275
    $label3.Location = $System_Drawing_Point
    $label3.Name = "label3"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = 18
    $System_Drawing_Size.Width = 100
    $label3.Size = $System_Drawing_Size
    $label3.TabIndex = 9
    $label3.Text = "Result :"

    $form1.Controls.Add($label3)

    $textArea.DataBindings.DefaultDataSourceUpdateMode = 0
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 22
    $System_Drawing_Point.Y = 296
    $textArea.Location = $System_Drawing_Point
    $textArea.Name = "textArea"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = 140
    $System_Drawing_Size.Width = 602
    $textArea.Size = $System_Drawing_Size
    $textArea.TabIndex = 8
    $textArea.Text = ""

    $form1.Controls.Add($textArea)

    $textToEncrypt.DataBindings.DefaultDataSourceUpdateMode = 0
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 201
    $System_Drawing_Point.Y = 110
    $textToEncrypt.Location = $System_Drawing_Point
    $textToEncrypt.Name = "textToEncrypt"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = 20
    $System_Drawing_Size.Width = 294
    $textToEncrypt.Size = $System_Drawing_Size
    $textToEncrypt.TabIndex = 7
    $textToEncrypt.text = "I want to encrypt this text"

    $form1.Controls.Add($textToEncrypt)

    $label2.DataBindings.DefaultDataSourceUpdateMode = 0

    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 22
    $System_Drawing_Point.Y = 110
    $label2.Location = $System_Drawing_Point
    $label2.Name = "label2"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = 23
    $System_Drawing_Size.Width = 171
    $label2.Size = $System_Drawing_Size
    $label2.TabIndex = 6
    $label2.Text = "Type the text you want to encrypt"

    $form1.Controls.Add($label2)

    $textFolder.DataBindings.DefaultDataSourceUpdateMode = 0
    $textFolder.Enabled = $False
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 201
    $System_Drawing_Point.Y = 39
    $textFolder.Location = $System_Drawing_Point
    $textFolder.Name = "textFolder"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = 20
    $System_Drawing_Size.Width = 294
    $textFolder.Size = $System_Drawing_Size
    $textFolder.TabIndex = 5
    $textFolder.text = "$env:USERPROFILE\desktop"

    $form1.Controls.Add($textFolder)

    $label1.DataBindings.DefaultDataSourceUpdateMode = 0

    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 22
    $System_Drawing_Point.Y = 42
    $label1.Location = $System_Drawing_Point
    $label1.Name = "label1"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = 23
    $System_Drawing_Size.Width = 132
    $label1.Size = $System_Drawing_Size
    $label1.TabIndex = 4
    $label1.Text = "Choose dest folder"
    $label1.add_Click($handler_label1_Click)

    $form1.Controls.Add($label1)


    $chooseFolder.DataBindings.DefaultDataSourceUpdateMode = 0

    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 520
    $System_Drawing_Point.Y = 42
    $chooseFolder.Location = $System_Drawing_Point
    $chooseFolder.Name = "chooseFolder"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = 23
    $System_Drawing_Size.Width = 75
    $chooseFolder.Size = $System_Drawing_Size
    $chooseFolder.TabIndex = 3
    $chooseFolder.Text = "Choose"
    $chooseFolder.UseVisualStyleBackColor = $True
    $chooseFolder.add_Click($chooseFolder_OnClick)

    $form1.Controls.Add($chooseFolder)


    $decrypt.DataBindings.DefaultDataSourceUpdateMode = 0

    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 22
    $System_Drawing_Point.Y = 237
    $decrypt.Location = $System_Drawing_Point
    $decrypt.Name = "decrypt"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = 23
    $System_Drawing_Size.Width = 75
    $decrypt.Size = $System_Drawing_Size
    $decrypt.TabIndex = 2
    $decrypt.Text = "Decrypt"
    $decrypt.UseVisualStyleBackColor = $True
    $decrypt.add_Click($decrypt_OnClick)

    $form1.Controls.Add($decrypt)


    $encrypt.DataBindings.DefaultDataSourceUpdateMode = 0

    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 520
    $System_Drawing_Point.Y = 108
    $encrypt.Location = $System_Drawing_Point
    $encrypt.Name = "encrypt"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = 23
    $System_Drawing_Size.Width = 75
    $encrypt.Size = $System_Drawing_Size
    $encrypt.TabIndex = 1
    $encrypt.Text = "Encrypt"
    $encrypt.UseVisualStyleBackColor = $True
    $encrypt.add_Click($encrypt_OnClick)

    $form1.Controls.Add($encrypt)

    #endregion Generated Form Code

    #Save the initial state of the form
    $InitialFormWindowState = $form1.WindowState
    #Init the OnLoad event to correct the initial state of the form
    $form1.add_Load($OnLoadForm_StateCorrection)
    #Show the Form
    $form1.ShowDialog() | Out-Null

} #End Function

#Call the Function
GenerateForm
