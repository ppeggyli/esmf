! $Id$
!
! Earth System Modeling Framework
! Copyright 2002-2020, University Corporation for Atmospheric Research,
! Massachusetts Institute of Technology, Geophysical Fluid Dynamics
! Laboratory, University of Michigan, National Centers for Environmental
! Prediction, Los Alamos National Laboratory, Argonne National Laboratory,
! NASA Goddard Space Flight Center.
! Licensed under the University of Illinois-NCSA License.
!
!==============================================================================

#define ESMF_FILENAME "ESMF_AttributeUtilUTest.F90"

#include "ESMF_Macros.inc"
#include "ESMF.h"

!==============================================================================
!==============================================================================
!==============================================================================

program ESMF_AttributeUtilUTest

!==============================================================================
!BOP
! !PROGRAM: ESMF_AttributeUtilUTest
!
! !DESCRIPTION:
!
!-----------------------------------------------------------------------------
! !USES:
  use ESMF_TestMod ! test methods
  use ESMF
  use ESMF_AttributeMod, only : ESMF_InfoFormatKey

  implicit none

!------------------------------------------------------------------------------
! The following line turns the CVS identifier string into a printable variable.
  character(*), parameter :: version = &
    '$Id$'
!------------------------------------------------------------------------------

!------------------------------------------------------------------------------
!==============================================================================

  character(ESMF_MAXSTR)      :: failMsg
  character(ESMF_MAXSTR)      :: name
  integer                     :: rc
  integer                     :: result = 0

  character(:), allocatable :: key, name_key, convention, purpose

  type(ESMF_FieldBundle) :: src_fb, dst_fb
  type(ESMF_Info) :: infoh, infoh2
  character(:), allocatable :: actual

!------------------------------------------------------------------------------
! The unit tests are divided into Sanity and Exhaustive. The Sanity tests are
! always run. When the environment variable, EXHAUSTIVE, is set to ON then
! the EXHAUSTIVE and sanity tests both run. If the EXHAUSTIVE variable is set
! to OFF, then only the sanity unit tests.
! Special strings (Non-exhaustive and exhaustive) have been
! added to allow a script to count the number and types of unit tests.
!------------------------------------------------------------------------------

  !----------------------------------------------------------------------------
  call ESMF_TestStart(ESMF_SRCLINE, rc=rc)  ! calls ESMF_Initialize() internally
  if (rc /= ESMF_SUCCESS) call ESMF_Finalize(endflag=ESMF_END_ABORT)
  !----------------------------------------------------------------------------

  !----------------------------------------------------------------------------
  !NEX_UTest
  write(name, *) "ESMF_InfoFormatKey w/ name"
  write(failMsg, *) "Did not return ESMF_SUCCESS"

  name_key = "AttributeName"
  call ESMF_InfoFormatKey(key, name_key, rc)
  if (rc /= ESMF_SUCCESS) call ESMF_Finalize(endflag=ESMF_END_ABORT)

  call ESMF_Test((rc .eq. ESMF_SUCCESS .and. &
                  key .eq. "/ESMF/General/AttributeName"), &
                  name, failMsg, result, ESMF_SRCLINE)
  ! Must abort to prevent possible hanging due to communications.
  if (rc /= ESMF_SUCCESS) call ESMF_Finalize(endflag=ESMF_END_ABORT)
  !----------------------------------------------------------------------------

  !----------------------------------------------------------------------------
  !NEX_UTest
  write(name, *) "Attribute copy by reference"
  write(failMsg, *) "Did not return ESMF_SUCCESS"

  src_fb = ESMF_FieldBundleCreate(name="src_fb", rc=rc)
  if (rc /= ESMF_SUCCESS) call ESMF_Finalize(endflag=ESMF_END_ABORT)

  dst_fb = ESMF_FieldBundleCreate(name="dst_fb", rc=rc)
  if (rc /= ESMF_SUCCESS) call ESMF_Finalize(endflag=ESMF_END_ABORT)

  call ESMF_AttributeCopy(src_fb, dst_fb, attcopy=ESMF_ATTCOPY_REFERENCE, rc=rc)
  if (rc /= ESMF_SUCCESS) call ESMF_Finalize(endflag=ESMF_END_ABORT)

  call ESMF_InfoGetFromHost(src_fb, infoh, rc=rc)
  if (rc /= ESMF_SUCCESS) call ESMF_Finalize(endflag=ESMF_END_ABORT)

  call ESMF_InfoSet(infoh, "/NetCDF/FV3/output_file", "out.nc", rc=rc)
  if (rc /= ESMF_SUCCESS) call ESMF_Finalize(endflag=ESMF_END_ABORT)

  call ESMF_InfoGetFromHost(dst_fb, infoh2, rc=rc)
  if (rc /= ESMF_SUCCESS) call ESMF_Finalize(endflag=ESMF_END_ABORT)

  call ESMF_InfoGetCharAlloc(infoh2, "/NetCDF/FV3/output_file", actual, rc=rc)
  if (rc /= ESMF_SUCCESS) call ESMF_Finalize(endflag=ESMF_END_ABORT)

  call ESMF_Test((actual .eq. "out.nc"), name, failMsg, result, ESMF_SRCLINE)
  ! Must abort to prevent possible hanging due to communications.
  if (rc /= ESMF_SUCCESS) call ESMF_Finalize(endflag=ESMF_END_ABORT)
  !----------------------------------------------------------------------------

  call ESMF_TestEnd(ESMF_SRCLINE) ! calls ESMF_Finalize() internally

end program ESMF_AttributeUtilUTest
