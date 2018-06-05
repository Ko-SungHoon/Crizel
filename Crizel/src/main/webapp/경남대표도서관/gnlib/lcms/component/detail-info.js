Vue.component('detailInfo', {
  template: [
      '<div class="detailInfo">',
        '<ul>',
        '<li><dl><dt>형태사항 : </dt><dd>{{record.PAGE}}, {{record.BOOK_SIZE}} </dd></dl></li>',
        '<li><dl><dt>ISBN : </dt><dd>{{record.ISBN}}</dd></dl></li>',
        '</ul>',
      '</div>',
  ].join(''),
  props: {
    record: {
      type: Object,
      required: true
    }
  },
  methods: {

  }
})