class Score::ResultListFactory < CacheDependendRecord
  belongs_to :list_factory, class_name: 'Score::ListFactory'
  belongs_to :result, class_name: 'Score::Result'
end
