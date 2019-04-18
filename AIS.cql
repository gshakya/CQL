library AdultImmunizationStatus version '0.0.031'

using QDM version '5.4'

include NCQA_Common version '4.7.000' called Common

codesystem "SNOMEDCT:2016-09": 'urn:oid:2.16.840.1.113883.6.96' version 'urn:hl7:version:2016-09'
codesystem "SNOMEDCT": 'urn:oid:2.16.840.1.113883.6.96'
codesystem "LOINC": 'urn:oid:2.16.840.1.113883.6.1'

valueset "Adult Influenza Vaccine": 'urn:oid:2.16.840.1.113883.3.464.1004.1476'
valueset "Anatomic or Functional Asplenia": 'urn:oid:2.16.840.1.113883.3.464.1004.1477'
valueset "Bone Marrow Transplant": 'urn:oid:2.16.840.1.113883.3.464.1004.1499'
valueset "Cerebrospinal Fluid Leak": 'urn:oid:2.16.840.1.113883.3.464.1004.1448'
valueset "Chemotherapy (1)": 'urn:oid:2.16.840.1.113883.3.464.1004.1519'
valueset "Chemotherapy (2)": 'urn:oid:2.16.840.1.113883.3.464.1004.1500'
valueset "Cochlear Implant (1)": 'urn:oid:2.16.840.1.113883.3.464.1004.1520'
valueset "Cochlear Implant (2)": 'urn:oid:2.16.840.1.113883.3.464.1004.1447'
valueset "Cochlear Implant (3)": 'urn:oid:2.16.840.1.113883.3.464.1004.1521'
valueset "Herpes Zoster Live Vaccine": 'urn:oid:2.16.840.1.113883.3.464.1004.1478'
valueset "Herpes Zoster Recombinant Vaccine": 'urn:oid:2.16.840.1.113883.3.464.1004.1494'
valueset "Hospice": 'urn:oid:2.16.840.1.113883.3.464.1004.1504'
valueset "Immunocompromising Conditions": 'urn:oid:2.16.840.1.113883.3.464.1004.1502'
valueset "Pneumococcal Conjugate Vaccine 13": 'urn:oid:2.16.840.1.113883.3.464.1004.1439'
valueset "Pneumococcal Polysaccharide Vaccine 23": 'urn:oid:2.16.840.1.113883.3.464.1004.1440'
valueset "Sickle Cell Anemia and HB-S Disease": 'urn:oid:2.16.840.1.113883.3.464.1004.1505'
valueset "Td Vaccine": 'urn:oid:2.16.840.1.113883.3.464.1004.1244'
valueset "Tdap Vaccine": 'urn:oid:2.16.840.1.113883.3.464.1004.1506'

code "Adverse reaction caused by zoster vaccine (disorder)": '451291000124104' from "SNOMEDCT:2016-09" display 'Adverse reaction caused by zoster vaccine (disorder)'
code "Anaphylaxis due to diphtheria and tetanus vaccine (disorder)": '428281000124107' from "SNOMEDCT" display 'Anaphylaxis due to diphtheria and tetanus vaccine (disorder)'
code "Anaphylaxis due to tetanus, diphtheria and acellular pertussis vaccine (disorder)": '428291000124105' from "SNOMEDCT" display 'Anaphylaxis due to tetanus, diphtheria and acellular pertussis vaccine (disorder)'
code "Birthdate": '21112-8' from "LOINC" display 'Birthdate'
code "Influenza virus vaccine adverse reaction (disorder)": '420113004' from "SNOMEDCT" display 'Influenza virus vaccine adverse reaction (disorder)'
code "Pneumococcal vaccine adverse reaction (disorder)": '293116002' from "SNOMEDCT" display 'Pneumococcal vaccine adverse reaction (disorder)'
code "Post diphtheria vaccination encephalitis (disorder)": '192711008' from "SNOMEDCT" display 'Post diphtheria vaccination encephalitis (disorder)'
code "Post pertussis vaccination encephalitis (disorder)": '192712001' from "SNOMEDCT" display 'Post pertussis vaccination encephalitis (disorder)'
code "Post tetanus vaccination encephalitis (disorder)": '192710009' from "SNOMEDCT" display 'Post tetanus vaccination encephalitis (disorder)'

parameter "Measurement Period" Interval<DateTime>

context Patient

define "Denominator 1":
	"Initial Population"


	// minus denominator exclusions

define "Denominator 2":
	"Initial Population"


	// minus denominator exclusions

define "Denominator 3":
	"Initial Population"
		and exists ( ["Patient Characteristic Birthdate"] BirthDate
				where Common."CalendarAgeInYearsAt"(BirthDate.birthDatetime, start of "Measurement Period")>= 50
		)


	// minus denominator exclusions

define "Denominator 4":
	"Initial Population"
		and exists ( ["Patient Characteristic Birthdate"] BirthDate
				where Common."CalendarAgeInYearsAt"(BirthDate.birthDatetime, start of "Measurement Period")>= 66
		)



	// minus denominator exclusions

define "Pneumococcal Conjugate Vaccine 13 after age 60":
	( ( ["Immunization, Administered": "Pneumococcal Conjugate Vaccine 13"]
			union ( ["Procedure, Performed": "Pneumococcal Conjugate Vaccine 13"] PneumoProc
					return "Immunization, Administered" { authorDatetime: start of PneumoProc.relevantPeriod }
			) ) V13
			with ["Patient Characteristic Birthdate"] BirthDate
				such that Common."CalendarAgeInYearsAt"(BirthDate.birthDatetime, V13.authorDatetime)>= 60
	)

define "Numerator 4":
	exists ( "Pneumococcal Conjugate Vaccine 13 after age 60" V13
			with "Pneumococcal Polysaccharide Vaccine 23 after age 60" V23
				such that months between V13.authorDatetime and V23.authorDatetime >= 12
					or months between V23.authorDatetime and V13.authorDatetime >= 12
	)
		or "Pneumococcal Vaccine Adverse Reaction"

define "Pneumococcal Polysaccharide Vaccine 23 after age 60":
	( ( ["Immunization, Administered": "Pneumococcal Polysaccharide Vaccine 23"]
			union ( ["Procedure, Performed": "Pneumococcal Polysaccharide Vaccine 23"] PneumoProc
					return "Immunization, Administered" { authorDatetime: start of PneumoProc.relevantPeriod }
			) ) V23
			with ["Patient Characteristic Birthdate"] BirthDate
				such that Common."CalendarAgeInYearsAt"(BirthDate.birthDatetime, V23.authorDatetime)>= 60
	)

define "Stratification 1":
	exists ( ["Patient Characteristic Birthdate"] BirthDate
			where Common."CalendarAgeInYearsAt"(BirthDate.birthDatetime, start of "Measurement Period")between 19 and 65
	)
		and exists ["Patient Characteristic Payer": Common."Medicaid"]

define "Stratification 2":
	exists ( ["Patient Characteristic Birthdate"] BirthDate
			where Common."CalendarAgeInYearsAt"(BirthDate.birthDatetime, start of "Measurement Period")between 19 and 65
	)
		and exists ["Patient Characteristic Payer": Common."Commercial"]

define "Stratification 3":
	exists ( ["Patient Characteristic Birthdate"] Birthdate
			where Common."CalendarAgeInYearsAt"(Birthdate.birthDatetime, start of "Measurement Period")>= 66
	)
		and exists ["Patient Characteristic Payer": Common."Medicare"]

define "Post Diphtheria Vaccination Encephalitis":
	exists ( ["Diagnosis": "Post diphtheria vaccination encephalitis (disorder)"] EncepDip
			where EncepDip.prevalencePeriod starts before
			end of "Measurement Period"
	)

define "Post Tetanus Vaccination Encephalitis":
	exists ( ["Diagnosis": "Post tetanus vaccination encephalitis (disorder)"] EncepTet
			where EncepTet.prevalencePeriod starts before
			end of "Measurement Period"
	)

define "Post Pertussis Vaccination Encephalitis":
	exists ( ["Diagnosis": "Post pertussis vaccination encephalitis (disorder)"] EncepPer
			where EncepPer.prevalencePeriod starts before
			end of "Measurement Period"
	)

define "Pneumococcal Vaccine Adverse Reaction":
	exists ( ["Diagnosis": "Pneumococcal vaccine adverse reaction (disorder)"] Anaphypneumo
			where Anaphypneumo.prevalencePeriod starts before
			end of "Measurement Period"
	)

define "Adverse Reaction Caused by Zoster Vaccine":
	exists ( ["Diagnosis": "Adverse reaction caused by zoster vaccine (disorder)"] Anaphyzoster
			where Anaphyzoster.prevalencePeriod starts before
			end of "Measurement Period"
	)

define "Anaphylaxis Due to Tdap Vaccine":
	exists ( ["Diagnosis": "Anaphylaxis due to tetanus, diphtheria and acellular pertussis vaccine (disorder)"] AnaphyTdap
			where AnaphyTdap.prevalencePeriod starts before
			end of "Measurement Period"
	)

define "Anaphylaxis Due to Td Vaccine":
	exists ( ["Diagnosis": "Anaphylaxis due to diphtheria and tetanus vaccine (disorder)"] AnaphyTd
			where AnaphyTd.prevalencePeriod starts before
			end of "Measurement Period"
	)

define "Numerator 3":
	exists ["Immunization, Administered": "Herpes Zoster Live Vaccine"] live
		with ["Patient Characteristic Birthdate"] BirthDate
			such that Common."CalendarAgeInYearsAt"(BirthDate.birthDatetime, live.authorDatetime)>= 50
				or "2 Doses of Recombinant Zoster Vaccine"
				or "Adverse Reaction Caused by Zoster Vaccine"

define "Influenza Virus Vaccine Adverse Reaction":
	exists ( ["Diagnosis": "Influenza virus vaccine adverse reaction (disorder)"] Adverseflu
			where Adverseflu.prevalencePeriod starts before
			end of "Measurement Period"
	)

define "Herpes Zoster Recombinant Vaccine After Age 50":
	["Immunization, Administered": "Herpes Zoster Recombinant Vaccine"] recombinant
		with ["Patient Characteristic Birthdate"] BirthDate
			such that Common."CalendarAgeInYearsAt"(BirthDate.birthDatetime, recombinant.authorDatetime)>= 50

define "2 Doses of Recombinant Zoster Vaccine":
	exists ( "Herpes Zoster Recombinant Vaccine After Age 50" Recombinant1
			with "Herpes Zoster Recombinant Vaccine After Age 50" Recombinant2
				such that days between Recombinant1.authorDatetime and Recombinant2.authorDatetime >= 28
	)

define "Numerator 1":
	exists ["Immunization, Administered": "Adult Influenza Vaccine"] flu
		where flu.authorDatetime during Interval[( start of "Measurement Period" - 6 months ), ( start of "Measurement Period" + 6 months ) )
			or "Influenza Virus Vaccine Adverse Reaction"

define "Numerator 2":
	exists ["Immunization, Administered": "Tdap Vaccine"] tdap
		where tdap.authorDatetime during Interval[( start of "Measurement Period" - 9 years ), (
			end of "Measurement Period"
		) )
			or exists ["Immunization, Administered": "Td Vaccine"] td
				where td.authorDatetime during Interval[( start of "Measurement Period" - 9 years ), (
					end of "Measurement Period"
				) )
					or "Anaphylaxis Due to Td Vaccine"
					or "Anaphylaxis Due to Tdap Vaccine"
					or "Post Tetanus Vaccination Encephalitis"
					or "Post Diphtheria Vaccination Encephalitis"
					or "Post Pertussis Vaccination Encephalitis"

define "Initial Population":
	exists ( ["Patient Characteristic Birthdate"] BirthDate
			where Common."CalendarAgeInYearsAt"(BirthDate.birthDatetime, start of "Measurement Period")>= 19
	)
		and ( Common."Is Enrolled"(Common."Commercial Product",
				end of "Measurement Period", "Measurement Period", 45
			)
				or Common."Is Enrolled"(Common."Medicaid Product",
					end of "Measurement Period", "Measurement Period", 45
				)
				or Common."Is Enrolled"(Common."Medicare Product",
					end of "Measurement Period", "Measurement Period", 45
				)
		)

define "Denominator Exclusions":
	exists ( ["Procedure, Performed": "Chemotherapy (1)"]
			union ["Encounter, Performed": "Chemotherapy (2)"] Chemo
				where Chemo.relevantPeriod overlaps "Measurement Period"
	)
		or exists ( ["Procedure, Performed": "Bone Marrow Transplant"] BoneMarrow
				where BoneMarrow.relevantPeriod overlaps "Measurement Period"
		)
		or exists ( ["Diagnosis": "Immunocompromising Conditions"] Immuno
				where Immuno.prevalencePeriod starts before
				end of "Measurement Period"
		)
		or exists ( ["Diagnosis": "Cochlear Implant (1)"] CochlearDx
				where CochlearDx.prevalencePeriod starts before
				end of "Measurement Period"
		)
		or exists ( ["Procedure, Performed": "Cochlear Implant (2)"] CochlearProc
				where CochlearProc.relevantPeriod starts before
				end of "Measurement Period"
		)
		or exists ( ["Device, Applied": "Cochlear Implant (3)"] CochlearDev
				where CochlearDev.relevantPeriod starts before
				end of "Measurement Period"
		)
		or exists ( ["Diagnosis": "Anatomic or Functional Asplenia"] Asplenia
				where Asplenia.prevalencePeriod starts before
				end of "Measurement Period"
		)
		or exists ( ["Diagnosis": "Sickle Cell Anemia and HB-S Disease"] SickleCell
				where SickleCell.prevalencePeriod starts before
				end of "Measurement Period"
		)
		or exists ( ["Diagnosis": "Cerebrospinal Fluid Leak"] CFL
				where CFL.prevalencePeriod starts before
				end of "Measurement Period"
		)
		or exists ( ( ["Intervention, Performed": "Hospice"] Hospice
					where Hospice.relevantPeriod overlaps "Measurement Period"
			)
				union ( ["Intervention, Order": "Hospice"] HospiceOrder
						where HospiceOrder.authorDatetime during "Measurement Period"
				)
		)
