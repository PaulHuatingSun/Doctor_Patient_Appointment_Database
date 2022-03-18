--**********************************************************************************************--
-- Title: Final Project Milestone03 (Assignment 9)
-- Author: Huating Sun
-- Desc: This file contains code for creating PatientAppointment DB
-- Change Log:
-- 2021-03-08, Huating Sun, Created File
--***********************************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment09DB_HSun')
	 Begin
	  Alter Database [Assignment09DB_HSun] Set Single_user With Rollback Immediate;
	  Drop Database Assignment09DB_HSun;
	 End
	Create Database Assignment09DB_HSun;
End Try
Begin Catch
	Print Error_Number();
End Catch
Go

Use Assignment09DB_HSun;

-- Create tables and views and stored procedures for Clinics
-- Create Clinics Table
Create Table Clinics (
  ClinicID int Constraint pkClinics Primary Key Not Null Identity(1, 1),
  ClinicName nvarchar(100) Constraint uniClinicName Unique Not Null,
  ClinicPhoneNumber nvarchar(100) Constraint checkClinicPhone Check
        (ClinicPhoneNumber LIKE '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]') Not Null,
  ClinicAddress nvarchar(100) Not Null,
  ClinicCity nvarchar(100) Not Null,
  ClinicState nchar(2) Not Null,
  ClinicZipCode nvarchar(10) Constraint checkClinicZipCode Check
        (ClinicZipCode LIKE '[0-9][0-9][0-9][0-9][0-9]' OR
         ClinicZipCode LIKE '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]') Not Null
);
Go

-- Create Clinics View 
Create View vClinics As
  Select 
	ClinicID, 
	ClinicName, 
	ClinicPhoneNumber, 
	ClinicAddress, 
	ClinicCity,
    ClinicState, 
	ClinicZipCode
  From Clinics;
Go

-- Create Inserting Procedure for Clinics Table
Create Procedure pInsClinics (
  @ClinicID int output,
  @ClinicName nvarchar(100),
  @ClinicPhoneNumber nvarchar(100),
  @ClinicAddress nvarchar(100),
  @ClinicCity nvarchar(100),
  @ClinicState nchar(2),
  @ClinicZipCode nvarchar(10)
)
/* Author: Huating Sun
** Desc: Insert Procedure for Clinics Table
** Change Log:
** 2021-03-08, Huating Sun, Created this Procedure.
*/
As
  Begin
    Declare @RC int = 0;
    Begin Try
      Begin Transaction
        Insert Into Clinics (
			ClinicName, 
			ClinicPhoneNumber, 
			ClinicAddress,
			ClinicCity, 
			ClinicState, 
			ClinicZipCode)
        Values (
			@ClinicName, 
			@ClinicPhoneNumber, 
			@ClinicAddress, 
			@ClinicCity,
			@ClinicState, 
			@ClinicZipCode);
      Commit Transaction
      Set @RC = +1
    End Try
    Begin Catch
      IF(@@Trancount > 0) Rollback Transaction
      Print Error_Message();
      Set @RC = -1
    End Catch
	Select @ClinicID = @@Identity;
    Return @RC;
  End
Go

-- Create Updating Procedure for Clinics Table
Create Procedure pUpdClinics (
  @ClinicID int output,
  @ClinicName nvarchar(100),
  @ClinicPhoneNumber nvarchar(100),
  @ClinicAddress nvarchar(100),
  @ClinicCity nvarchar(100),
  @ClinicState nchar(2),
  @ClinicZipCode nvarchar(10)
)
/* Author: Huating Sun
** Desc: Updating Procedure for Clinics Table
** Change Log:
** 2021-03-08, Huating Sun, Created this Procedure.
*/
As
  Begin
    Declare @RC int = 0;
    Begin Try
      Begin Transaction
        Update Clinics Set
          ClinicName = @ClinicName,
          ClinicPhoneNumber = @ClinicPhoneNumber,
          ClinicAddress = @ClinicAddress,
          ClinicCity = @ClinicCity,
          ClinicState = @ClinicState,
          ClinicZipCode = @ClinicZipCode
        Where
          ClinicID = @ClinicID;
      Commit Transaction
      Set @RC = +1
    End Try
    Begin Catch
      IF(@@Trancount > 0) Rollback Transaction
      Print Error_Message();
      Set @RC = -1
    End Catch
	Select @ClinicID = @@Identity;
    Return @RC;
  End
Go

-- Create Deleting Producedure for CLinics Table
Create Procedure pDelClinics (
  @ClinicID int output
)
/* Author: Huating Sun
** Desc: Deleting Producedure for CLinics Table
** Change Log:
** 2021-03-08, Huating Sun, Created this Procedure.
*/
As
  Begin
    Declare @RC int = 0;
    Begin Try
      Begin Transaction
        Delete From Clinics Where ClinicID = @ClinicID;
      Commit Transaction
      Set @RC = +1
    End Try
    Begin Catch
      IF(@@Trancount > 0) Rollback Transaction
      Print Error_Message();
      Set @RC = -1
    End Catch
	Select @ClinicID = @@Identity;
    Return @RC;
  End
Go

-- Create tables and views and stored procedures for Patients
-- Create Patients Table
Create Table Patients (
  PatientID int Constraint pkPatientID Primary Key Not Null Identity(1, 1),
  PatientFirstName nvarchar(100) Not Null,
  PatientLastName nvarchar(100) Not Null,
  PatientPhoneNumber nvarchar(100) Constraint checkPatientPhone Check
        (PatientPhoneNumber LIKE '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]') Not Null,
  PatientAddress nvarchar(100) Not Null,
  PatientCity nvarchar(100) Not Null,
  PatientState nchar(2) Not Null,
  PatientZipCode nvarchar(10) Constraint checkPatientZipCode Check
        (PatientZipCode LIKE '[0-9][0-9][0-9][0-9][0-9]' OR
         PatientZipCode LIKE '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]') Not Null
);
Go

-- Create View for Patients
Create View vPatients As
  Select 
	PatientID, 
	PatientFirstName, 
	PatientLastName, 
	PatientPhoneNumber,
	PatientAddress, 
	PatientCity, 
	PatientState, 
	PatientZipCode
  From Patients;
Go

-- Create Inserting Procedure for Patients
Create Procedure pInsPatients (
  @PatientID int output,
  @PatientFirstName nvarchar(100),
  @PatientLastName nvarchar(100),
  @PatientPhoneNumber nvarchar(100),
  @PatientAddress nvarchar(100),
  @PatientCity nvarchar(100),
  @PatientState nchar(2),
  @PatientZipCode nvarchar(10)
)
/* Author: Huating Sun
** Desc: Inserting Procedure for Patients
** Change Log:
** 2021-03-08, Huating Sun, Created this Procedure.
*/
As
  Begin
    Declare @RC int = 0;
    Begin Try
      Begin Transaction
        Insert Into Patients (
			PatientFirstName, 
			PatientLastName, 
			PatientPhoneNumber,
			PatientAddress, 
			PatientCity, 
			PatientState, 
			PatientZipCode)
        Values (
			@PatientFirstName, 
			@PatientLastName, 
			@PatientPhoneNumber,
			@PatientAddress, 
			@PatientCity, 
			@PatientState, 
			@PatientZipCode);
      Commit Transaction
      Set @RC = +1
    End Try
    Begin Catch
      IF(@@Trancount > 0) Rollback Transaction
      Print Error_Message();
      Set @RC = -1
    End Catch
	Select @PatientID = @@Identity;
    Return @RC;
  End
Go

-- Creating Updating Procedure for Patients
Create Procedure pUpdPatients (
  @PatientID int output,
  @PatientFirstName nvarchar(100),
  @PatientLastName nvarchar(100),
  @PatientPhoneNumber nvarchar(100),
  @PatientAddress nvarchar(100),
  @PatientCity nvarchar(100),
  @PatientState nchar(2),
  @PatientZipCode nvarchar(10)
)
/* Author: Huating Sun
** Desc: Updating Procedure for Patients
** Change Log:
** 2021-03-08, Huating Sun, Created this Procedure.
*/
As
  Begin
    Declare @RC int = 0;
    Begin Try
      Begin Transaction
        Update Patients Set
          PatientFirstName = @PatientFirstName,
          PatientLastName = @PatientLastName,
          PatientPhoneNumber = @PatientPhoneNumber,
          PatientAddress = @PatientAddress,
          PatientCity = @PatientCity,
          PatientState = @PatientState,
          PatientZipCode = @PatientZipCode
        Where
          PatientID = @PatientID;
      Commit Transaction
      Set @RC = +1
    End Try
    Begin Catch
      IF(@@Trancount > 0) Rollback Transaction
      Print Error_Message();
      Set @RC = -1
    End Catch
	Select @PatientID = @@Identity;
    Return @RC;
  End
Go

-- Create Deleting Procedure for Patients
Create Procedure pDelPatients (
  @PatientID int output
)
/* Author: Huating Sun
** Desc: Deleting Procedure for Patients
** Change Log:
** 2021-03-08, Huating Sun, Created this Procedure.
*/
As
  Begin
    Declare @RC int = 0;
    Begin Try
      Begin Transaction
        Delete From Patients Where PatientID = @PatientID;
      Commit Transaction
      Set @RC = +1
    End Try
    Begin Catch
      IF(@@Trancount > 0) Rollback Transaction
      Print Error_Message();
      Set @RC = -1
    End Catch
	Select @PatientID = @@Identity;
    Return @RC;
  End
Go

-- Create tables and views and stored procedures for Doctors
-- Create Doctors Table
Create Table Doctors (
  DoctorID int Constraint pkDoctorID Primary Key Not Null Identity(1, 1),
  DoctorFirstName nvarchar(100) Not Null,
  DoctorLastName nvarchar(100) Not Null,
  DoctorPhoneNumber nvarchar(100) Constraint checkDoctorPhone Check
        (DoctorPhoneNumber LIKE '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]') Not Null,
  DoctorAddress nvarchar(100) Not Null,
  DoctorCity nvarchar(100) Not Null,
  DoctorState nchar(2) Not Null,
  DoctorZipCode nvarchar(10) Constraint checkDoctorZipCode Check
        (DoctorZipCode LIKE '[0-9][0-9][0-9][0-9][0-9]' OR
         DoctorZipCode LIKE '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]') Not Null
);
Go

-- Create View for Doctors
Create View vDoctors As
  Select 
	DoctorID, 
	DoctorFirstName, 
	DoctorLastName, 
	DoctorPhoneNumber,
	DoctorAddress, 
	DoctorCity, 
	DoctorState, 
	DoctorZipCode
  From Doctors;
Go

-- Create Inserting Procedure for Doctors
Create Procedure pInsDoctors (
  @DoctorID int output,
  @DoctorFirstName nvarchar(100),
  @DoctorLastName nvarchar(100),
  @DoctorPhoneNumber nvarchar(100),
  @DoctorAddress nvarchar(100),
  @DoctorCity nvarchar(100),
  @DoctorState nchar(2),
  @DoctorZipCode nvarchar(10)
)
/* Author: Huating Sun
** Desc: Inserting Procedure for Doctors
** Change Log:
** 2021-03-08, Huating Sun, Created this Procedure.
*/
As
  Begin
    Declare @RC int = 0;
    Begin Try
      Begin Transaction
        Insert Into Doctors (
			DoctorFirstName, 
			DoctorLastName, 
			DoctorPhoneNumber,
			DoctorAddress, 
			DoctorCity, 
			DoctorState, 
			DoctorZipCode)
        Values (
			@DoctorFirstName, 
			@DoctorLastName, 
			@DoctorPhoneNumber,
			@DoctorAddress, 
			@DoctorCity, 
			@DoctorState, 
			@DoctorZipCode);
      Commit Transaction
      Set @RC = +1
    End Try
    Begin Catch
      IF(@@Trancount > 0) Rollback Transaction
      Print Error_Message();
      Set @RC = -1
    End Catch
	Select @DoctorID = @@Identity;
    Return @RC;
  End
Go

-- Creating Updating Procedure for Doctors
Create Procedure pUpdDoctors (
  @DoctorID int output,
  @DoctorFirstName nvarchar(100),
  @DoctorLastName nvarchar(100),
  @DoctorPhoneNumber nvarchar(100),
  @DoctorAddress nvarchar(100),
  @DoctorCity nvarchar(100),
  @DoctorState nchar(2),
  @DoctorZipCode nvarchar(10)
)
/* Author: Huating Sun
** Desc: Creating Updating Procedure for Doctors
** Change Log:
** 2021-03-08, Huating Sun, Created this Procedure.
*/
As
  Begin
    Declare @RC int = 0;
    Begin Try
      Begin Transaction
        Update Doctors Set
          DoctorFirstName = @DoctorFirstName,
          DoctorLastName = @DoctorLastName,
          DoctorPhoneNumber = @DoctorPhoneNumber,
          DoctorAddress = @DoctorAddress,
          DoctorCity = @DoctorCity,
          DoctorState = @DoctorState,
          DoctorZipCode = @DoctorZipCode
        Where
          DoctorID = @DoctorID;
      Commit Transaction
      Set @RC = +1
    End Try
    Begin Catch
      IF(@@Trancount > 0) Rollback Transaction
      Print Error_Message();
      Set @RC = -1
    End Catch
	Select @DoctorID = @@Identity;
    Return @RC;
  End
Go

-- Create Deleting Procedure for Doctors
Create Procedure pDelDoctors (
  @DoctorID int output
)
/* Author: Huating Sun
** Desc: Deleting Procedure for Doctors
** Change Log:
** 2021-03-08, Huating Sun, Created this Procedure.
*/
As
  Begin
    Declare @RC int = 0;
    Begin Try
      Begin Transaction
        Delete From Doctors Where DoctorID = @DoctorID;
      Commit Transaction
      Set @RC = +1
    End Try
    Begin Catch
      IF(@@Trancount > 0) Rollback Transaction
      Print Error_Message();
      Set @RC = -1
    End Catch
	Select @DoctorID = @@Identity;
    Return @RC;
  End
Go

-- Create tables and views and stored procedures for Appointments
-- Create Appointments Table
Create Table Appointments (
  AppointmentID int Constraint pkAppointment Primary Key Not Null Identity(1, 1),
  AppointmentDateTime Datetime Not Null,
  AppointmentPatientID int Constraint fkAppointmentPatients Foreign Key (AppointmentPatientID) References Patients(PatientID) Not Null,
  AppointmentDoctorID  int Constraint fkAppointmentDoctors Foreign Key (AppointmentDoctorID) References Doctors(DoctorID) Not Null,
  AppointmentClinicID  int Constraint fkAppointmentClinicID Foreign Key (AppointmentClinicID) References Clinics(ClinicID) Not Null
);
Go

-- Create View for Appointments
Create View vAppointments As
  Select 
	AppointmentID, 
	AppointmentDateTime, 
	AppointmentPatientID,
	AppointmentDoctorID, 
	AppointmentClinicID
  From Appointments;
Go

-- Create Inserting Procedure for Appointments
Create Procedure pInsAppointments (
  @AppointmentID int output,
  @AppointmentDateTime  Datetime,
  @AppointmentPatientID int,
  @AppointmentDoctorID  int,
  @AppointmentClinicID  int
)
/* Author: Huating Sun
** Desc: Inserting Procedure for Appointments
** Change Log:
** 2021-03-08, Huating Sun, Created this Procedure.
*/
As
  Begin
    Declare @RC int = 0;
    Begin Try
      Begin Transaction
        Insert Into Appointments (
			AppointmentDateTime, 
			AppointmentPatientID,
			AppointmentDoctorID, 
			AppointmentClinicID)
        Values (
			@AppointmentDateTime, 
			@AppointmentPatientID, 
			@AppointmentDoctorID,
			@AppointmentClinicID);
      Commit Transaction
      Set @RC = +1
    End Try
    Begin Catch
      IF(@@Trancount > 0) Rollback Transaction
      Print Error_Message();
      Set @RC = -1
    End Catch
	Select @AppointmentID = @@Identity;
    Return @RC;
  End
Go

-- Create Updating Procedure for Appointments
Create Procedure pUpdAppointments (
  @AppointmentID int output,
  @AppointmentDateTime Datetime,
  @AppointmentPatientID int,
  @AppointmentDoctorID int,
  @AppointmentClinicID int
)
/* Author: Huating Sun
** Desc: Updating Procedure for Appointments
** Change Log:
** 2021-03-08, Huating Sun, Created this Procedure.
*/
As
  Begin
    Declare @RC int = 0;
    Begin Try
      Begin Transaction
        Update Appointments Set
          AppointmentDateTime = @AppointmentDateTime,
          AppointmentPatientID = @AppointmentPatientID,
          AppointmentDoctorID = @AppointmentDoctorID,
          AppointmentClinicID = @AppointmentClinicID
        Where
          AppointmentID = @AppointmentID;
      Commit Transaction
      Set @RC = +1
    End Try
    Begin Catch
      IF(@@Trancount > 0) Rollback Transaction
      Print Error_Message();
      Set @RC = -1
    End Catch
	Select @AppointmentID = @@Identity;
    Return @RC;
  End
Go

-- Create Deleting Procedure for Doctors
Create Procedure pDelAppointments (
  @AppointmentID int output
)
/* Author: Huating Sun
** Desc: Deleting Procedure for Doctors
** Change Log:
** 2021-03-08, Huating Sun, Created this Procedure.
*/
As
  Begin
    Declare @RC int = 0;
    Begin Try
      Begin Transaction
        Delete From Appointments Where AppointmentID = @AppointmentID;
      Commit Transaction
      Set @RC = +1
    End Try
    Begin Catch
      IF(@@Trancount > 0) Rollback Transaction
      Print Error_Message();
      Set @RC = -1
    End Catch
	Select @AppointmentID = @@Identity;
    Return @RC;
  End
Go

-- Create a summary view for all the info above
Create View vAppointmentsByPatientsDoctorsAndClinics As
  Select A.AppointmentID,
         Format(Cast(A.AppointmentDateTime As Date), 'MM/dd/yyyy') As AppointmentDate,
         Format(Cast(A.AppointmentDateTime As Time), 'hh:mm') As AppointmentTime,
         P.PatientID,
         P.PatientFirstName + ' ' + P.PatientLastName As PatientName,
         P.PatientPhoneNumber,
         P.PatientAddress,
         P.PatientCity,
         P.PatientState,
         P.PatientZipCode,
         D.DoctorID,
         D.DoctorFirstName + ' ' + D.DoctorLastName As DoctorName,
         D.DoctorPhoneNumber,
         D.DoctorAddress,
         D.DoctorCity,
         D.DoctorState,
         D.DoctorZipCode,
         C.ClinicID,
         C.ClinicName,
         C.ClinicPhoneNumber,
         C.ClinicAddress,
         C.ClinicCity,
         C.ClinicState,
         C.ClinicZipCode
  From Appointments As A
  Join Patients As P On P.PatientID = A.AppointmentPatientID
  Join Doctors As D On D.DoctorID = A.AppointmentDoctorID
  Join Clinics As C On C.ClinicID = A.AppointmentClinicID;
Go

-- Grant and Deny Access for Users
Deny Select, Insert, Update On Patients To Public;
Deny Select, Insert, Update On Doctors To Public;
Deny Select, Insert, Update On Clinics To Public;
Deny Select, Insert, Update On Appointments To Public;
Grant Select On vPatients To Public;
Grant Select On vDoctors To Public;
Grant Select On vClinics To Public;
Grant Select On vAppointments To Public;
Grant Select On vAppointmentsByPatientsDoctorsAndClinics To Public;
Grant Execute On pInsPatients To Public;
Grant Execute On pUpdPatients To Public;
Grant Execute On pDelPatients To Public;
Grant Execute On pInsDoctors To Public;
Grant Execute On pUpdDoctors To Public;
Grant Execute On pDelDoctors To Public;
Grant Execute On pInsClinics To Public;
Grant Execute On pUpdClinics To Public;
Grant Execute On pDelClinics To Public;
Grant Execute On pInsAppointments To Public;
Grant Execute On pUpdAppointments To Public;
Grant Execute On pDelAppointments To Public;

-- -- Test Insert Procedures
-- Declare @Status int;
-- Declare @id int;
-- Exec @Status = pInsClinics
--   @CLinicID = @id output,
--   @ClinicName = 'Google Clinic',
--   @ClinicPhoneNumber = '206-468-5185',
--   @ClinicAddress = '123 Main Street',
--   @ClinicCity = 'Seattle',
--   @ClinicState = 'WA',
--   @ClinicZipCode = '98225'
-- Select [pInsClinics Status] = @Status;
-- Select * From Clinics;
-- Select @id;
-- Go
--
-- Declare @Status int;
-- Declare @id int;
-- Exec @Status = pInsPatients
--   @PatientID = @id output,
--   @PatientFirstName = 'Jack',
--   @PatientLastName = 'Benelli',
--   @PatientPhoneNumber = '123-456-7890',
--   @PatientAddress = '524 Main Street',
--   @PatientCity = 'Belleve',
--   @PatientState = 'WA',
--   @PatientZipCode = '96234'
-- Select [pInsPatients Status] = @Status;
-- Select * From Patients;
-- Select @id;
-- Go
--
-- Declare @Status int;
-- Declare @id int;
-- Exec @Status = pInsDoctors
--   @DoctorID = @id output,
--   @DoctorFirstName = 'Will',
--   @DoctorLastName = 'Holman',
--   @DoctorPhoneNumber = '206-575-8627',
--   @DoctorAddress = '678 Main Street',
--   @DoctorCity = 'Seattle',
--   @DoctorState = 'WA',
--   @DoctorZipCode = '98223'
-- Select [pInsDoctors Status] = @Status;
-- Select * From Doctors;
-- Select @id;
-- Go
--
-- Declare @Status int;
-- Declare @id int;
-- Exec @Status = pInsAppointments
--   @AppointmentID = @id output,
--   @AppointmentDateTime = '2020-09-17 00:39:50',
--   @AppointmentPatientID = '1',
--   @AppointmentDoctorID = '1',
--   @AppointmentClinicID = '1'
-- Select [pInsAppointments Status] = @Status;
-- Select * From Appointments;
-- Select @id;
-- Go
-- -- Test Update Procedures
-- Declare @Status int;
-- Exec @Status = pUpdAppointments
--   @AppointmentID = 1,
--   @AppointmentDateTime = '2020-08-17 00:10:50',
--   @AppointmentPatientID = '1',
--   @AppointmentDoctorID = '1',
--   @AppointmentClinicID = '1'
-- Select [pUpdAppointments Status] = @Status;
-- Select * From Appointments;
-- Go
--
-- Declare @Status int;
-- Exec @Status = pUpdClinics
--   @CLinicID = 1,
--   @ClinicName = 'Sohu Clinic',
--   @ClinicPhoneNumber = '206-467-5185',
--   @ClinicAddress = '125 Main Street',
--   @ClinicCity = 'Seattle',
--   @ClinicState = 'WA',
--   @ClinicZipCode = '98235'
-- Select [pUpdClinics Status] = @Status;
-- Select * From Clinics;
-- Go
--
-- Declare @Status int;
-- Exec @Status = pUpdPatients
--   @PatientID = 1,
--   @PatientFirstName = 'John',
--   @PatientLastName = 'Benelli',
--   @PatientPhoneNumber = '123-457-7890',
--   @PatientAddress = '514 Main Street',
--   @PatientCity = 'Belleve',
--   @PatientState = 'WA',
--   @PatientZipCode = '96234'
-- Select [pUpdPatients Status] = @Status;
-- Select * From Patients;
-- Go
--
-- Declare @Status int;
-- Exec @Status = pUpdDoctors
--   @DoctorID = 1,
--   @DoctorFirstName = 'Will',
--   @DoctorLastName = 'Holmanson',
--   @DoctorPhoneNumber = '210-571-8627',
--   @DoctorAddress = '670 Main Street',
--   @DoctorCity = 'Seattle',
--   @DoctorState = 'WA',
--   @DoctorZipCode = '98223'
-- Select [pUpdDoctors Status] = @Status;
-- Select * From Doctors;
-- Go
--
--
-- -- Test Delete Procedures
-- Declare @Status int;
-- Exec @Status = pDelAppointments
--   @AppointmentID = 1;
-- Select [pDelAppointments Status] = @Status;
-- Select * From Appointments;
-- Go
--
-- Declare @Status int;
-- Exec @Status = pDelClinics
--   @CLinicID = 1;
-- Select [pDelClinics Status] = @Status;
-- Select * From Clinics;
-- Go
--
-- Declare @Status int;
-- Exec @Status = pDelPatients
--   @PatientID = 1;
-- Select [pDelPatients Status] = @Status;
-- Select * From Patients;
-- Go
--
-- Declare @Status int;
-- Exec @Status = pDelDoctors
--   @DoctorID = 1;
-- Select [pDelDoctors Status] = @Status;
-- Select * From Doctors;
-- Go

-- Insert Data to Clinics Table
Insert Into Clinics (ClinicName, ClinicPhoneNumber, ClinicAddress, ClinicCity, ClinicState, ClinicZipCode) Values ('Twitternation', '213-824-0543', '3 Buell Terrace', 'North Hollywood', 'CA', 96486);
Insert Into Clinics (ClinicName, ClinicPhoneNumber, ClinicAddress, ClinicCity, ClinicState, ClinicZipCode) Values ('Photobug', '859-106-6129', '69173 Fairfield Pass', 'Lexington', 'KY', 98686);
Insert Into Clinics (ClinicName, ClinicPhoneNumber, ClinicAddress, ClinicCity, ClinicState, ClinicZipCode) Values ('Jaloo', '813-138-5732', '76233 Meadow Vale Street', 'Clearwater', 'CA', 91367);
Insert Into Clinics (ClinicName, ClinicPhoneNumber, ClinicAddress, ClinicCity, ClinicState, ClinicZipCode) Values ('Fadeo', '202-733-8504', '48196 Northwestern Way', 'Washington', 'DC', 98138);
Insert Into Clinics (ClinicName, ClinicPhoneNumber, ClinicAddress, ClinicCity, ClinicState, ClinicZipCode) Values ('Skalith', '619-679-7776', '9 Muir Court', 'San Diego', 'CA', 98553);

-- Insert Data to Doctors Table
Insert Into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode) Values ('Val', 'Morley', '219-896-6840', '50596 Rockefeller Plaza', 'Gary', 'IN', 94203);
Insert Into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode) Values ('Blaine', 'Howley', '650-795-7486', '26 Golf Course Street', 'Redwood City', 'CA', 96451);
Insert Into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode) Values ('Sheela', 'Spaxman', '816-332-9138', '10 Melby Way', 'Kansas City', 'MO', 93834);
Insert Into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode) Values ('Dale', 'Vernall', '202-957-4922', '0007 Jana Avenue', 'Washington', 'DC', 91330);
Insert Into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode) Values ('Wye', 'Scase', '916-237-1967', '547 Westport Lane', 'Sacramento', 'CA', 92554);
Insert Into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode) Values ('Cody', 'Reace', '501-682-3979', '25595 Algoma Terrace', 'North Little Rock', 'AR', 94509);
Insert Into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode) Values ('Trisha', 'Lukash', '859-165-7108', '994 Bashford Parkway', 'Lexington', 'KY', 96060);
Insert Into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode) Values ('Aube', 'Gillbe', '702-528-2716', '406 Shopko Pass', 'Las Vegas', 'NV', 91950);
Insert Into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode) Values ('Tracey', 'Dickens', '719-276-0005', '01463 Transport Alley', 'Colorado Springs', 'CO', 94181);
Insert Into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode) Values ('Stewart', 'Carsey', '214-961-1358', '653 Novick Place', 'Dallas', 'TX', 97763);

-- Insert Data to Patients Table
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Tommi', 'Cello', '205-811-1949', '755 Nova Parkway', 'Birmingham', 'AL', 96239);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Peria', 'McKeller', '727-811-8181', '6696 Lillian Plaza', 'Clearwater', 'FL', 96479);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Angele', 'Uc', '918-494-3614', '7 Bunker Hill Hill', 'Tulsa', 'OK', 95661);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Phineas', 'Szymoni', '918-307-0498', '254 Schiller Park', 'Tulsa', 'OK', 98896);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Alvinia', 'Hallor', '206-582-5477', '0 Hoard Crossing', 'Seattle', 'WA', 94561);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Archibaldo', 'Schohier', '608-218-5604', '878 Magdeline Alley', 'Madison', 'WI', 97357);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Jorgan', 'Seamen', '713-136-4223', '2 Bobwhite Point', 'Houston', 'TX', 96498);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Aaren', 'Teasdale', '323-597-8891', '2 Sugar Center', 'Los Angeles', 'CA', 91637);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Darell', 'Burdis', '717-423-2747', '3793 Dayton Park', 'Lancaster', 'PA', 91844);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Roobbie', 'Chalcraft', '480-899-6382', '408 Schlimgen Park', 'Mesa', 'AZ', 94631);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Annabella', 'Alyukin', '208-220-6628', '32 Boyd Way', 'Portland', 'OR', 93682);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Cobb', 'Leven', '917-675-8878', '5353 Ilene Parkway', 'Brooklyn', 'NY', 95853);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Roosevelt', 'Strainge', '917-123-1552', '2 Mayer Point', 'New York City', 'NY', 90000);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Mari', 'Coop', '512-953-7348', '0 Westend Alley', 'Austin', 'TX', 90029);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Godfrey', 'Pyer', '813-887-2639', '1 Debs Hill', 'Tampa', 'FL', 91260);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Buffy', 'Damper', '617-956-2275', '0 Nelson Park', 'Lynn', 'MA', 90203);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Veronika', 'Seaking', '404-691-4441', '329 Boyd Pass', 'Atlanta', 'GA', 91331);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Elinore', 'Vallow', '334-905-1068', '1 Crownhardt Plaza', 'Montgomery', 'AL', 93237);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Lexie', 'Salerg', '518-445-7811', '4299 Spaight Parkway', 'Albany', 'NY', 92212);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Rubia', 'Emmins', '703-146-8456', '413 Hoffman Plaza', 'Arlington', 'VA', 92487);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Fraze', 'Gillie', '404-149-7397', '61 Hovde Crossing', 'Atlanta', 'GA', 94862);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Willyt', 'Wharin', '209-849-6612', '203 Ilene Road', 'Fresno', 'CA', 91928);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Cary', 'Halbord', '406-232-0209', '4 Armistice Trail', 'Bozeman', 'MT', 93161);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Roseanne', 'Batson', '805-153-0947', '14383 Jenifer Crossing', 'Simi Valley', 'CA', 92049);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Colas', 'Vernay', '704-683-4047', '45187 Scoville Junction', 'Charlotte', 'NC', 91263);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Velma', 'Erat', '916-906-1858', '811 Texas Drive', 'Sacramento', 'CA', 91471);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Kermit', 'Baigent', '770-416-0346', '9896 Gulseth Park', 'Atlanta', 'GA', 95153);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Dacie', 'Pennycock', '720-424-0740', '8615 Portage Drive', 'Littleton', 'CO', 93434);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Damaris', 'Doche', '425-510-2845', '4834 Linden Street', 'Seattle', 'WA', 94374);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Nicholle', 'Ordemann', '315-819-0134', '72 Dottie Crossing', 'Syracuse', 'NY', 91222);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Muffin', 'Petel', '318-393-6119', '72 Old Gate Parkway', 'Monroe', 'LA', 91709);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Nettle', 'O''Spillane', '202-408-7475', '49764 Basil Trail', 'Washington', 'DC', 92633);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Leticia', 'Ginni', '765-572-5780', '7919 Esch Court', 'Crawfordsville', 'IN', 92909);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Constancy', 'Borwick', '516-445-8706', '1295 Texas Crossing', 'Jamaica', 'NY', 90246);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Leonardo', 'Lintill', '281-838-2201', '754 Kennedy Drive', 'Galveston', 'TX', 91420);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Marcel', 'Hiland', '432-697-9423', '125 Jenna Alley', 'Midland', 'TX', 92344);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Sutherland', 'Daverin', '913-704-8787', '073 Randy Court', 'Shawnee Mission', 'KS', 92358);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Netty', 'Norville', '240-857-2564', '732 Raven Place', 'Frederick', 'MD', 95606);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Herman', 'Helbeck', '806-601-1784', '8892 Aberg Trail', 'Lubbock', 'TX', 92192);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Rozalie', 'Boykett', '562-678-9570', '5 Hoepker Plaza', 'Long Beach', 'CA', 94067);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Putnem', 'Selwyn', '864-984-4880', '67 7th Court', 'Anderson', 'SC', 93726);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Bobinette', 'Ceaplen', '786-300-6699', '84521 Havey Junction', 'Miami', 'FL', 95058);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Lesley', 'Cinderey', '510-400-2796', '8064 Duke Alley', 'Berkeley', 'CA', 95402);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Smitty', 'Thornally', '480-662-2529', '281 Bartillon Place', 'Scottsdale', 'AZ', 94981);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Florina', 'Spackman', '702-320-6905', '25439 Monica Point', 'Las Vegas', 'NV', 92934);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Davon', 'Corser', '478-230-8863', '529 La Follette Street', 'Macon', 'GA', 92609);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Barnard', 'Lacy', '562-819-0294', '82 Schiller Point', 'Whittier', 'CA', 90113);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Sella', 'Keyzor', '623-139-3538', '05346 Kedzie Alley', 'Glendale', 'AZ', 90776);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Jania', 'Muskett', '404-229-1026', '7758 Lunder Park', 'Atlanta', 'GA', 94409);
Insert Into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) Values ('Felicdad', 'Sansum', '281-862-2629', '94391 Anzinger Junction', 'Houston', 'TX', 90956);

-- Insert Data to Appointments Table
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('1/3/2021', 1, 4, 3);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('8/24/2020', 2, 10, 3);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('10/12/2020', 3, 2, 1);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('3/14/2020', 4, 9, 2);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('1/3/2021', 5, 7, 2);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('6/16/2020', 6, 9, 4);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('8/13/2020', 7, 9, 1);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('11/9/2020', 8, 8, 3);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('10/3/2020', 9, 4, 2);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('2/14/2021', 10, 6, 1);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('2/24/2021', 11, 7, 4);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('2/28/2021', 12, 1, 4);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('3/29/2020', 13, 4, 4);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('7/27/2020', 14, 8, 4);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('1/13/2021', 15, 6, 4);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('11/25/2020', 16, 4, 3);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('6/13/2020', 17, 9, 3);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('7/4/2020', 18, 5, 1);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('11/27/2020', 19, 5, 3);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('8/12/2020', 20, 8, 2);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('7/27/2020', 21, 7, 5);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('1/18/2021', 22, 3, 4);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('1/18/2021', 23, 3, 5);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('4/9/2020', 24, 4, 4);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('6/19/2020', 25, 7, 4);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('9/18/2020', 26, 1, 4);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('10/15/2020', 27, 6, 1);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('7/28/2020', 28, 1, 1);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('8/31/2020', 29, 4, 4);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('3/9/2020', 30, 7, 2);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('2/1/2021', 31, 10, 2);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('12/7/2020', 32, 4, 4);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('2/18/2021', 33, 5, 3);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('3/6/2021', 34, 10, 2);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('7/26/2020', 35, 6, 5);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('7/19/2020', 36, 8, 2);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('12/24/2020', 37, 3, 2);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('1/7/2021', 38, 2, 1);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('12/4/2020', 39, 3, 3);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('4/15/2020', 40, 1, 1);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('4/21/2020', 41, 2, 1);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('11/29/2020', 42, 5, 3);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('7/26/2020', 43, 9, 1);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('4/16/2020', 44, 9, 1);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('8/2/2020', 45, 4, 4);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('2/7/2021', 46, 9, 5);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('7/26/2020', 47, 8, 3);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('8/3/2020', 48, 5, 4);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('12/26/2020', 49, 6, 2);
Insert Into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) Values ('1/31/2021', 50, 9, 2);
Go

-- Create two complex views
Create View vAppointmentsByDoctors As
Select Top 100000 
		DoctorFirstName + ' ' + DoctorLastname As DoctorName,
		Count(*) As DoctorAppointment 
	From Appointments As A
	Join Doctors As D On D.DoctorID = A.AppointmentDoctorID
	Group By DoctorID, DoctorFirstName, DoctorLastName
	Order By DoctorAppointment;
Go

Create View vAppointmentsByClinics As
Select Top 100000
	ClinicName, Count(*) As ClinicsAppointment From Appointments As A
	Join Clinics As C On C.ClinicID = A.AppointmentClinicID
	Group By ClinicID, ClinicName
	Order By ClinicsAppointment;
Go
	