/* 
 * Copyright 2014 FLR Team. Distributed under the GPL 2 or later
 * Maintainer: Finlay Scott, JRC
 */

// Necessary check to avoid the redefinition of FLQuant_base in the RcppExports.cpp
#ifndef _FLQuant_base_
#define _FLQuant_base_
#include "FLQuant_base.h"
#endif

#ifndef _fwdSR_
#define _fwdSR_
#include "fwdSR.h"
#endif

#define _fwdBiol_

/*
 * fwdBiol class
 * Contains biological information (incuding abundance) by age for making projections
 * It's very similar to the FLBiol class in R but also includes SRR information
 */

/*-------------------------------------------------------------------*/
template <typename T>
class fwdBiol_base {
    public:
        /* Constructors */
		fwdBiol_base();
		fwdBiol_base(const SEXP flb_sexp); // Used as intrusive 'as', takes an FLBiolcpp but with no SRR deviances information
        fwdBiol_base(const SEXP flb_sexp, const fwdSR_base<T> srr_in);  // Pass in FLBiol and fwdSR
        fwdBiol_base(const SEXP flb_sexp, const std::string model_name, const FLQuant params, const FLQuant deviances, const bool deviances_mult); // Pass in FLBiol and bits of fwdSR
        fwdBiol_base(const SEXP flb_sexp, const FLQuant deviances, const bool deviances_mult); // Pass in FLBiol and bits of fwdSR
        
        operator SEXP() const; // Used as intrusive 'wrap' - returns an FLBiolcpp

		fwdBiol_base(const fwdBiol_base& fwdBiol_base_source); // copy constructor to ensure that copy is a deep copy - used when passing FLSs into functions
		fwdBiol_base& operator = (const fwdBiol_base& fwdBiol_base_source); // Assignment operator for a deep copy

        // Get accessors with const reinforced
        FLQuant_base<T> n() const;
        FLQuant_base<T> n(const std::vector<unsigned int> indices_min, const std::vector<unsigned int> indices_max) const;
        FLQuant wt() const;
        FLQuant wt(const std::vector<unsigned int> indices_min, const std::vector<unsigned int> indices_max) const;
        FLQuant m() const;
        FLQuant m(const std::vector<unsigned int> indices_min, const std::vector<unsigned int> indices_max) const;
        FLQuant spwn() const;
        FLQuant spwn(const std::vector<unsigned int> indices_min, const std::vector<unsigned int> indices_max) const;
        FLQuant fec() const;
        FLQuant fec(const std::vector<unsigned int> indices_min, const std::vector<unsigned int> indices_max) const;
        FLQuant mat() const;
        FLQuant mat(const std::vector<unsigned int> indices_min, const std::vector<unsigned int> indices_max) const;
        std::string get_name() const;
        std::string get_desc() const;
        Rcpp::NumericVector get_range() const;
        fwdSR_base<T> get_srr() const;

        // Accessor methods (get and set) for the slots
        FLQuant_base<T>& n();
        // Set individual elements (faster than going through FLQuant get and set)
		T& n(const unsigned int quant, const unsigned int year, const unsigned int unit, const unsigned int season, const unsigned int area, const unsigned int iter);
        FLQuant& wt();
        FLQuant& m();
        FLQuant& spwn();
        FLQuant& fec();
        FLQuant& mat();

        // SRR accessors
        FLQuant_base<T> predict_recruitment(const FLQuant_base<T> srp, const std::vector<unsigned int> initial_params_indices);
        bool does_recruitment_happen(unsigned int unit, unsigned int year, unsigned int season) const;
        bool has_recruitment_happened(unsigned int unit, unsigned int year, unsigned int season) const;

        // Summary and other methods
        FLQuant_base<T> biomass() const;
        FLQuant_base<T> biomass(const std::vector<unsigned int> indices_min, const std::vector<unsigned int> indices_max) const; // subsetting
        unsigned int srp_timelag() const;

    private:
        std::string name;
        std::string desc;
        Rcpp::NumericVector range;
        FLQuant_base<T> n_flq;
        FLQuant wt_flq;
        FLQuant m_flq;
        FLQuant spwn_flq;
        FLQuant fec_flq;
        FLQuant mat_flq;
        fwdSR_base<T> srr;
};

typedef fwdBiol_base<double> fwdBiol;
typedef fwdBiol_base<adouble> fwdBiolAD;

/*----------------------------------------------*/
// FLBiols class - a vector of FLBiols objects

template <typename T>
class fwdBiols_base {
    public:
        /* Constructors */
		fwdBiols_base();
		fwdBiols_base(SEXP flbs_sexp); // takes a list of fwdBiol objects components as an SEXP - used as as
		fwdBiols_base(fwdBiol_base<T>& flb); // Constructor from an fwdBiol object

		fwdBiols_base(const fwdBiols_base& fwdBiols_base_source); // copy constructor to ensure that copy is a deep copy 
		fwdBiols_base& operator = (const fwdBiols_base& fwdBiols_base_source); // Assignment operator for a deep copy

        operator SEXP() const; // Used as intrusive 'wrap' - returns an FLBiols

        // Accessors
		fwdBiol_base<T> operator () (const unsigned int element = 1) const; // Only gets an fwdBiol so const reinforced. Default is the first element
		fwdBiol_base<T>& operator () (const unsigned int element = 1); // Gets and sets an fwdBiol so const not reinforced

        void operator() (const fwdBiol_base<T>& flb); // Add another fwdBiol_base<T> to the data
        unsigned int get_nbiols() const;

        /* begin and end and const versions for iterators */
        typedef typename std::vector<fwdBiol_base<T> >::iterator iterator;
        iterator begin();
        iterator end();
        typedef typename std::vector<fwdBiol_base<T> >::const_iterator const_iterator;
        const_iterator begin() const;
        const_iterator end() const;

    protected:
        std::vector<fwdBiol_base<T> > biols;
        Rcpp::CharacterVector names; // of the biols
};

typedef fwdBiols_base<double> fwdBiols;
typedef fwdBiols_base<adouble> fwdBiolsAD;


