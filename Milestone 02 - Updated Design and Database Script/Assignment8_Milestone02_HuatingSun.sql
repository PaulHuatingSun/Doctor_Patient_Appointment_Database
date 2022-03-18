--**********************************************************************************************--
-- Title: Final Project Milestone02 (Assignment 8)
-- Author: Huating Sun
-- Desc: This file contains code for creating PatientAppointment DB
-- Change Log:
-- 2021-03-08, Huating Sun, Created File
--***********************************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment08DB_HSun')
	 Begin
	  Alter Database [Assignment08DB_HSun] Set Single_user With Rollback Immediate;
	  Drop Database Assignment08DB_HSun;
	 End
	Create Database Assignment08DB_HSun;
End Try
Begin Catch
	Print Error_Number();
End Catch
Go

Use Assignment08DB_HSun;

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
         Format(Cast(A.AppointmentDateTime As Date), 'MM/DD/YYYY') As AppointmentDate,
         Format(Cast(A.AppointmentDateTime As Time), 'HH:MM') As AppointmentTime,
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

-- Test Insert Procedures
Declare @Status int;
Declare @id int;
Exec @Status = pInsClinics
  @CLinicID = @id output,
  @ClinicName = 'Google Clinic',
  @ClinicPhoneNumber = '206-468-5185',
  @ClinicAddress = '123 Main Street',
  @ClinicCity = 'Seattle',
  @ClinicState = 'WA',
  @ClinicZipCode = '98225'
Select [pInsClinics Status] = @Status;
Select * From Clinics;
Select @id;
Go

Declare @Status int;
Declare @id int;
Exec @Status = pInsPatients
  @PatientID = @id output,
  @PatientFirstName = 'Jack',
  @PatientLastName = 'Benelli',
  @PatientPhoneNumber = '123-456-7890',
  @PatientAddress = '524 Main Street',
  @PatientCity = 'Belleve',
  @PatientState = 'WA',
  @PatientZipCode = '96234'
Select [pInsPatients Status] = @Status;
Select * From Patients;
Select @id;
Go

Declare @Status int;
Declare @id int;
Exec @Status = pInsDoctors
  @DoctorID = @id output,
  @DoctorFirstName = 'Will',
  @DoctorLastName = 'Holman',
  @DoctorPhoneNumber = '206-575-8627',
  @DoctorAddress = '678 Main Street',
  @DoctorCity = 'Seattle',
  @DoctorState = 'WA',
  @DoctorZipCode = '98223'
Select [pInsDoctors Status] = @Status;
Select * From Doctors;
Select @id;
Go

Declare @Status int;
Declare @id int;
Exec @Status = pInsAppointments
  @AppointmentID = @id output,
  @AppointmentDateTime = '2020-09-17 00:39:50',
  @AppointmentPatientID = '1',
  @AppointmentDoctorID = '1',
  @AppointmentClinicID = '1'
Select [pInsAppointments Status] = @Status;
Select * From Appointments;
Select @id;
Go
-- Test Update Procedures
Declare @Status int;
Exec @Status = pUpdClinics
  @CLinicID = 1,
  @ClinicName = 'Sohu Clinic',
  @ClinicPhoneNumber = '206-467-5185',
  @ClinicAddress = '125 Main Street',
  @ClinicCity = 'Seattle',
  @ClinicState = 'WA',
  @ClinicZipCode = '98235'
Select [pUpdClinics Status] = @Status;
Select * From Clinics;
Go

Declare @Status int;
Exec @Status = pUpdPatients
  @PatientID = 1,
  @PatientFirstName = 'John',
  @PatientLastName = 'Benelli',
  @PatientPhoneNumber = '123-457-7890',
  @PatientAddress = '514 Main Street',
  @PatientCity = 'Belleve',
  @PatientState = 'WA',
  @PatientZipCode = '96234'
Select [pUpdPatients Status] = @Status;
Select * From Patients;
Go

Declare @Status int;
Exec @Status = pUpdDoctors
  @DoctorID = 1,
  @DoctorFirstName = 'Will',
  @DoctorLastName = 'Holmanson',
  @DoctorPhoneNumber = '210-571-8627',
  @DoctorAddress = '670 Main Street',
  @DoctorCity = 'Seattle',
  @DoctorState = 'WA',
  @DoctorZipCode = '98223'
Select [pUpdDoctors Status] = @Status;
Select * From Doctors;
Go

Declare @Status int;
Exec @Status = pUpdAppointments
  @AppointmentID = 1,
  @AppointmentDateTime = '2020-08-17 00:10:50',
  @AppointmentPatientID = '1',
  @AppointmentDoctorID = '1',
  @AppointmentClinicID = '1'
Select [pUpdAppointments Status] = @Status;
Select * From Appointments;
Go
-- Test Delete Procedures
Declare @Status int;
Exec @Status = pDelAppointments
  @AppointmentID = 1;
Select [pDelAppointments Status] = @Status;
Select * From Appointments;
Go

Declare @Status int;
Exec @Status = pDelClinics
  @CLinicID = 1;
Select [pDelClinics Status] = @Status;
Select * From Clinics;
Go

Declare @Status int;
Exec @Status = pDelPatients
  @PatientID = 1;
Select [pDelPatients Status] = @Status;
Select * From Patients;
Go

Declare @Status int;
Exec @Status = pDelDoctors
  @DoctorID = 1;
Select [pDelDoctors Status] = @Status;
Select * From Doctors;
Go

