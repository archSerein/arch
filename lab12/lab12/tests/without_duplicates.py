test = {
  'name': 'without-duplicates',
  'points': 1,
  'suites': [
    {
      'cases': [
        {
          'code': r"""
          scm> (without-duplicates (list 5 4 2))
          4662ea133505c0c7f3bc0e02598ce600
          # locked
          """,
          'hidden': False,
          'locked': True,
          'multiline': False
        },
        {
          'code': r"""
          scm> (without-duplicates (list 5 4 5 4 2 2))
          4662ea133505c0c7f3bc0e02598ce600
          # locked
          scm> (without-duplicates (list 5 5 5 5 5))
          ff467c902f9c61cbaf6a2a64cc998df7
          # locked
          scm> (without-duplicates ())
          afed03a4bad4b019a15373c410ea3792
          # locked
          """,
          'hidden': False,
          'locked': True,
          'multiline': False
        },
        {
          'code': r"""
          scm> (without-duplicates '(5 4 3 2 1))
          (5 4 3 2 1)
          scm> (without-duplicates '(5 4 3 2 1 1))
          (5 4 3 2 1)
          scm> (without-duplicates '(5 5 4 3 2 1))
          (5 4 3 2 1)
          scm> (without-duplicates '(12))
          (12)
          scm> (without-duplicates '(1 1 1 1 1 1))
          (1)
          """,
          'hidden': False,
          'locked': False,
          'multiline': False
        }
      ],
      'scored': True,
      'setup': r"""
      scm> (load-all ".")
      """,
      'teardown': '',
      'type': 'scheme'
    }
  ]
}
