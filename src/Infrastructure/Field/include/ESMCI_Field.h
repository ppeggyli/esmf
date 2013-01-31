
// $Id: ESMCI_Field.h,v 1.20 2012/07/18 22:21:24 rokuingh Exp $
//
// Earth System Modeling Framework
// Copyright 2002-2013, University Corporation for Atmospheric Research, 
// Massachusetts Institute of Technology, Geophysical Fluid Dynamics 
// Laboratory, University of Michigan, National Centers for Environmental 
// Prediction, Los Alamos National Laboratory, Argonne National Laboratory, 
// NASA Goddard Space Flight Center.
// Licensed under the University of Illinois-NCSA License.
//
//-------------------------------------------------------------------------
// (all lines below between the !BOP and !EOP markers will be included in
//  the automated document processing.)
//-------------------------------------------------------------------------
// these lines prevent this file from being read more than once if it
// ends up being included multiple times

#ifndef ESMCI_Field_H
#define ESMCI_Field_H

//-----------------------------------------------------------------------------
//BOP
// !CLASS:  ESMC_Field - one line general Fieldment about this class
//
// !DESCRIPTION:
//
// The code in this file defines the ESMC Field class prototypes for the
// fortran interface routines. The companion file ESMC\_Field_C.F90  contains
// the definitions (full code bodies) for the interface routines.
//
//EOP 
//

//-----------------------------------------------------------------------------
// 
// !USES:
#include "ESMC_Field.h"
#include "ESMC_Mesh.h"
#include "ESMC_Array.h"
#include "ESMC_ArraySpec.h"
#include "ESMC_RHandle.h"
#include "ESMCI_RHandle.h"
#include "ESMCI_F90Interface.h"
#include "ESMC_Interface.h"
#include "ESMCI_LogErr.h"
#include "ESMF_LogMacros.inc"             // for LogErr
#include "ESMCI_Util.h"
#include "ESMC_Grid.h"


//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// C++ Field class declaration
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
namespace ESMCI{

  class Field{
    // pointer to fortran derived type
    F90ClassHolder fortranclass;
    // methods
   public:
    Field(){}
    Field(F90ClassHolder fc){
      fortranclass = fc;
    }
    // TODO: ESMC objects should be cast to ESMCI objects in the ESMC layer
    static Field* create(ESMC_Grid *grid, ESMC_ArraySpec arrayspec,
      ESMC_StaggerLoc staggerloc, ESMC_InterfaceInt *gridToFieldMap, 
      ESMC_InterfaceInt *ungriddedLBound, ESMC_InterfaceInt *ungriddedUBound, 
      const char *name, int *rc); 
    static Field* create(ESMC_Grid *grid, ESMC_TypeKind_Flag typekind,
      ESMC_StaggerLoc staggerloc, ESMC_InterfaceInt *gridToFieldMap, 
      ESMC_InterfaceInt *ungriddedLBound, ESMC_InterfaceInt *ungriddedUBound, 
      const char *name, int *rc); 
    static Field* create(ESMC_Mesh mesh, ESMC_ArraySpec arrayspec,
      ESMC_InterfaceInt *gridToFieldMap, ESMC_InterfaceInt *ungriddedLBound,
      ESMC_InterfaceInt *ungriddedUBound, const char *name, int *rc); 
    static Field* create(ESMC_Mesh mesh, ESMC_TypeKind_Flag typekind,
      ESMC_MeshLoc_Flag meshloc, ESMC_InterfaceInt *gridToFieldMap, 
      ESMC_InterfaceInt *ungriddedLBound, ESMC_InterfaceInt *ungriddedUBound, 
      const char *name, int *rc); 
    static int destroy(Field *field);
    ESMC_Mesh getMesh(int *rc);
    ESMC_Array getArray(int *rc);
    int print();
    int castToFortran(F90ClassHolder *fc);
    static int regridgetarea(Field *field);
    static int regridstore(Field *fieldsrc, Field *fielddst,
                           ESMC_InterfaceInt *srcMaskValues, 
                           ESMC_InterfaceInt *dstMaskValues,
                           RouteHandle **routehandle,
		                       ESMC_RegridMethod_Flag *regridMethod, 
                           ESMC_UnmappedAction_Flag *unmappedAction,
                           Field *srcFracField, Field *dstFracField);
    static int regrid(Field *fieldsrc, Field *fielddst, 
                      RouteHandle *routehandle, ESMC_Region_Flag *zeroRegion);
    static int regridrelease(RouteHandle *routehandle);
  }; 
}

#endif  // ESMCI_Field_H
